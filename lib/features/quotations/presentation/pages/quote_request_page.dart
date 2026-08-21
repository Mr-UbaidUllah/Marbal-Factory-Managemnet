import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../domain/entities/quote.dart';
import '../../domain/entities/quote_item.dart';
import '../../domain/entities/quote_status.dart';
import '../bloc/quote_bloc.dart';
import '../bloc/quote_event.dart';
import '../bloc/quote_request_bloc.dart';
import '../bloc/quote_state.dart';

class QuoteRequestPage extends StatefulWidget {
  const QuoteRequestPage({super.key, String? productId});

  @override
  State<QuoteRequestPage> createState() => _QuoteRequestPageState();
}

class _QuoteRequestPageState extends State<QuoteRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request a Quotation'),
      ),
      body: BlocBuilder<QuoteRequestBloc, QuoteRequestState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Your quotation request is empty.'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Browse Products'),
                  ),
                ],
              ),
            );
          }

          return BlocListener<QuoteBloc, QuoteState>(
            listener: (context, blocState) {
              if (blocState.status == QuoteStatusState.success && blocState.selectedQuote != null) {
                context.read<QuoteRequestBloc>().add(ClearRequest());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quotation request submitted successfully!')),
                );
                context.go('/quotes/${blocState.selectedQuote!.id}');
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildItemsList(state.items)),
                  const SizedBox(width: 24),
                  Expanded(flex: 1, child: _buildRequestForm(state.items)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemsList(List<QuoteItem> items) {
    return CustomCard(
      title: 'Selected Products',
      margin: const EdgeInsets.only(bottom: 16), onTap: () {  },
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('SKU: ${item.sku}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (item.quantity > 1) {
                      context.read<QuoteRequestBloc>().add(UpdateRequestQuantity(item.productId, item.quantity - 1));
                    }
                  },
                ),
                Text('${item.quantity.toInt()} ${item.unit}', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    context.read<QuoteRequestBloc>().add(UpdateRequestQuantity(item.productId, item.quantity + 1));
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    context.read<QuoteRequestBloc>().add(RemoveProductFromRequest(item.productId));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequestForm(List<QuoteItem> items) {
    return CustomCard(
      title: 'Your Contact Information',
      margin: const EdgeInsets.only(bottom: 16), onTap: () {  },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name *'),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number *'),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email Address'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Delivery Address'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Additional Notes'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final quote = Quote(
                      id: '',
                      quoteNumber: '',
                      requesterName: _nameController.text,
                      requesterPhone: _phoneController.text,
                      requesterEmail: _emailController.text,
                      requesterAddress: _addressController.text,
                      status: QuoteStatus.pending,
                      items: items,
                      subtotal: 0,
                      discount: 0,
                      tax: 0,
                      deliveryCharges: 0,
                      total: 0,
                      customerNotes: _notesController.text,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    context.read<QuoteBloc>().add(CreateQuoteEvent(quote));
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Submit Quotation Request'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
