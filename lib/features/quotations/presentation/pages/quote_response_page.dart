import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../domain/entities/quote.dart';
import '../../domain/entities/quote_item.dart';
import '../../domain/repositories/quote_repository.dart';
import '../../domain/services/quote_calculator.dart';
import '../bloc/quote_bloc.dart';
import '../bloc/quote_event.dart';
import '../bloc/quote_state.dart';

class QuoteResponsePage extends StatefulWidget {
  final String quoteId;

  const QuoteResponsePage({super.key, required this.quoteId});

  @override
  State<QuoteResponsePage> createState() => _QuoteResponsePageState();
}

class _QuoteResponsePageState extends State<QuoteResponsePage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _priceControllers = [];
  final List<TextEditingController> _itemDiscountControllers = [];
  final _discountController = TextEditingController(text: '0');
  final _taxController = TextEditingController(text: '15'); // Default 15%
  final _deliveryController = TextEditingController(text: '0');
  final _validUntilController = TextEditingController();
  final _adminNotesController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));

  @override
  void initState() {
    super.initState();
    context.read<QuoteBloc>().add(GetQuoteDetail(widget.quoteId));
    _validUntilController.text = _selectedDate.toIso8601String().split('T')[0];
  }

  void _initControllers(Quote quote) {
    if (_priceControllers.length != quote.items.length) {
      _priceControllers.clear();
      _itemDiscountControllers.clear();
      for (var item in quote.items) {
        _priceControllers.add(TextEditingController(text: item.quotedPrice.toString()));
        _itemDiscountControllers.add(TextEditingController(text: item.discount.toString()));
      }
    }
  }

  @override
  void dispose() {
    for (var c in _priceControllers) {
      c.dispose();
    }
    for (var c in _itemDiscountControllers) {
      c.dispose();
    }
    _discountController.dispose();
    _taxController.dispose();
    _deliveryController.dispose();
    _validUntilController.dispose();
    _adminNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuoteBloc, QuoteState>(
      listener: (context, state) {
        if (state.status == QuoteStatusState.success && state.selectedQuote?.status.name == 'Quoted') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Quotation response sent successfully')),
          );
          context.pop();
        }
      },
      builder: (context, state) {
        if (state.status == QuoteStatusState.loading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final quote = state.selectedQuote;
        if (quote == null) return const Scaffold(body: Center(child: Text('Quote not found')));

        _initControllers(quote);

        return Scaffold(
          appBar: AppBar(
            title: Text('Respond to ${quote.quoteNumber}'),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildItemsPricing(quote),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildAdditionalDetails()),
                      const SizedBox(width: 24),
                      Expanded(flex: 1, child: _buildLiveCalculations(quote)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomBar(context, quote),
        );
      },
    );
  }

  Widget _buildItemsPricing(Quote quote) {
    return CustomCard(
      title: 'Item Pricing',
      margin: const EdgeInsets.only(bottom: 16), onTap: () {  },
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: quote.items.length,
        itemBuilder: (context, index) {
          final item = quote.items[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Qty: ${item.quantity} ${item.unit}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _priceControllers[index],
                    decoration: const InputDecoration(labelText: 'Unit Price (SAR)', prefixText: 'SAR '),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _itemDiscountControllers[index],
                    decoration: const InputDecoration(labelText: 'Item Discount', prefixText: 'SAR '),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdditionalDetails() {
    return CustomCard(
      title: 'Quotation Settings',
      margin: const EdgeInsets.only(bottom: 16), onTap: () {  },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _taxController,
                  decoration: const InputDecoration(labelText: 'Tax Rate (%)', suffixText: '%'),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _deliveryController,
                  decoration: const InputDecoration(labelText: 'Delivery Charges', prefixText: 'SAR '),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _validUntilController,
            decoration: const InputDecoration(
              labelText: 'Valid Until',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                  _validUntilController.text = picked.toIso8601String().split('T')[0];
                });
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _adminNotesController,
            decoration: const InputDecoration(labelText: 'Admin Notes (Optional)'),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildLiveCalculations(Quote quote) {
    // Collect data for calculation
    final List<QuoteItem> updatedItems = [];
    for (int i = 0; i < quote.items.length; i++) {
      updatedItems.add(quote.items[i].copyWith(
        quotedPrice: double.tryParse(_priceControllers[i].text) ?? 0,
        discount: double.tryParse(_itemDiscountControllers[i].text) ?? 0,
      ));
    }

    final totals = QuoteCalculator.calculate(
      items: updatedItems,
      taxRate: (double.tryParse(_taxController.text) ?? 0) / 100,
      deliveryCharges: double.tryParse(_deliveryController.text) ?? 0,
    );

    return CustomCard(
      title: 'Summary',
      margin: const EdgeInsets.only(bottom: 16), onTap: () {  },
      child: Column(
        children: [
          _summaryRow('Items Subtotal', totals.subtotal),
          _summaryRow('Total Discount', -totals.discount),
          _summaryRow('Tax', totals.tax),
          _summaryRow('Delivery', totals.deliveryCharges),
          const Divider(thickness: 2),
          _summaryRow('Final Total', totals.total, isBold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text('SAR ${value.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, Quote quote) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              final List<QuoteItemUpdate> itemUpdates = [];
              for (int i = 0; i < quote.items.length; i++) {
                itemUpdates.add(QuoteItemUpdate(
                  itemId: quote.items[i].id,
                  quotedPrice: double.tryParse(_priceControllers[i].text) ?? 0,
                  discount: double.tryParse(_itemDiscountControllers[i].text) ?? 0,
                ));
              }

              context.read<QuoteBloc>().add(RespondToQuoteEvent(
                    id: quote.id,
                    items: itemUpdates,
                    tax: (double.tryParse(_taxController.text) ?? 0),
                    deliveryCharges: double.tryParse(_deliveryController.text),
                    validUntil: _selectedDate,
                    adminNotes: _adminNotesController.text,
                  ));
            },
            child: const Text('Send Quotation'),
          ),
        ],
      ),
    );
  }
}
