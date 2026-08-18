import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../domain/entities/quote.dart';
import '../../domain/entities/quote_status.dart';
import '../bloc/quote_bloc.dart';
import '../bloc/quote_event.dart';
import '../bloc/quote_state.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';
import '../../../orders/presentation/bloc/order_event.dart';
import '../../../orders/presentation/bloc/order_state.dart';

class QuoteDetailsPage extends StatefulWidget {
  final String quoteId;
  final bool isAdmin;

  const QuoteDetailsPage({super.key, required this.quoteId, this.isAdmin = false});

  @override
  State<QuoteDetailsPage> createState() => _QuoteDetailsPageState();
}

class _QuoteDetailsPageState extends State<QuoteDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<QuoteBloc>().add(GetQuoteDetail(widget.quoteId));
    // Load orders to check if this quote already has an order
    context.read<OrderBloc>().add(LoadOrders(query: widget.quoteId));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OrderBloc, OrderState>(
          listenWhen: (previous, current) => 
            previous.status == OrderStatusState.submitting && current.status == OrderStatusState.success,
          listener: (context, state) {
            if (state.selectedOrder != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order created successfully')),
              );
              context.go('/dashboard/orders/${state.selectedOrder!.id}');
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isAdmin ? 'Manage Quotation' : 'Quotation Details'),
          actions: [
            BlocBuilder<QuoteBloc, QuoteState>(
              builder: (context, quoteState) {
                final quote = quoteState.selectedQuote;
                if (quote == null) return const SizedBox.shrink();

                return BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, orderState) {
                    final existingOrder = orderState.orders.any((o) => o.quoteId == quote.id) 
                        ? orderState.orders.firstWhere((o) => o.quoteId == quote.id) 
                        : null;

                    return Row(
                      children: [
                        // Admin Actions
                        if (widget.isAdmin) ...[
                          if (quote.status == QuoteStatus.pending)
                            TextButton.icon(
                              onPressed: () => context.read<QuoteBloc>().add(ReviewQuoteEvent(quote.id)),
                              icon: const Icon(Icons.rate_review),
                              label: const Text('Review Request'),
                            ),
                          if (quote.status == QuoteStatus.underReview)
                            ElevatedButton.icon(
                              onPressed: () => context.go('/dashboard/quotations/${quote.id}/respond'),
                              icon: const Icon(Icons.reply),
                              label: const Text('Prepare Response'),
                            ),
                          if (quote.status == QuoteStatus.accepted)
                            existingOrder != null
                                ? ElevatedButton.icon(
                                    onPressed: () => context.go('/dashboard/orders/${existingOrder.id}'),
                                    icon: const Icon(Icons.visibility),
                                    label: const Text('View Order'),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                  )
                                : ElevatedButton.icon(
                                    onPressed: () => _showCreateOrderDialog(context, quote),
                                    icon: const Icon(Icons.add_shopping_cart),
                                    label: const Text('Create Order'),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                  ),
                        ],

                        // Public Actions
                        if (!widget.isAdmin && quote.status == QuoteStatus.quoted) ...[
                          ElevatedButton(
                            onPressed: () => _showAcceptDialog(context, quote),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: const Text('Accept Quote'),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () => _showRejectDialog(context, quote),
                            child: const Text('Reject'),
                          ),
                        ],
                        const SizedBox(width: 16),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<QuoteBloc, QuoteState>(
          builder: (context, state) {
            if (state.status == QuoteStatusState.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final quote = state.selectedQuote;
            if (quote == null) return const Center(child: Text('Quote not found.'));

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(quote),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildItemsList(quote),
                            if (widget.isAdmin) ...[
                              const SizedBox(height: 24),
                              _buildHistory(quote),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            _buildRequesterInfo(quote),
                            const SizedBox(height: 24),
                            _buildSummary(quote),
                            if (quote.validUntil != null) ...[
                              const SizedBox(height: 24),
                              _buildValidityCard(quote),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCreateOrderDialog(BuildContext context, Quote quote) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Order'),
        content: Text('Do you want to create an order from quotation ${quote.quoteNumber}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              context.read<OrderBloc>().add(CreateOrderFromQuoteEvent(quote.id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Create Order'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Quote quote) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () {},
      title: 'Quotation',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(quote.quoteNumber, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text('Last Updated: ${DateFormat('MMM dd, yyyy HH:mm').format(quote.updatedAt)}'),
              ],
            ),
            _StatusBadge(status: quote.status),
          ],
        ),
      ),
    );
  }

  Widget _buildRequesterInfo(Quote quote) {
    return CustomCard(
      title: 'Requester Details',
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(Icons.person, 'Name', quote.requesterName),
          _infoRow(Icons.phone, 'Phone', quote.requesterPhone),
          if (quote.requesterEmail != null) _infoRow(Icons.email, 'Email', quote.requesterEmail!),
          const Divider(),
          const Text('Customer Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(quote.customerNotes ?? 'No notes provided.'),
        ],
      ),
    );
  }

  Widget _buildItemsList(Quote quote) {
    return CustomCard(
      title: 'Requested Items',
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () {},
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1.5),
          3: FlexColumnWidth(1.5),
        },
        children: [
          const TableRow(
            children: [
              Padding(padding: EdgeInsets.all(8.0), child: Text('Product', style: TextStyle(fontWeight: FontWeight.bold))),
              Padding(padding: EdgeInsets.all(8.0), child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
              Padding(padding: EdgeInsets.all(8.0), child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
              Padding(padding: EdgeInsets.all(8.0), child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          ...quote.items.map((item) => TableRow(
            children: [
              Padding(padding: const EdgeInsets.all(8.0), child: Text(item.productName)),
              Padding(padding: const EdgeInsets.all(8.0), child: Text('${item.quantity} ${item.unit}')),
              Padding(padding: const EdgeInsets.all(8.0), child: Text('SAR ${item.quotedPrice.toStringAsFixed(2)}')),
              Padding(padding: const EdgeInsets.all(8.0), child: Text('SAR ${item.subtotal.toStringAsFixed(2)}')),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildSummary(Quote quote) {
    return CustomCard(
      title: 'Financial Summary',
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () {},
      child: Column(
        children: [
          _summaryRow('Subtotal', quote.subtotal),
          _summaryRow('Discount', -quote.discount),
          _summaryRow('Tax', quote.tax),
          _summaryRow('Delivery', quote.deliveryCharges),
          const Divider(thickness: 2),
          _summaryRow('Final Total', quote.total, isBold: true),
        ],
      ),
    );
  }

  Widget _buildHistory(Quote quote) {
    return CustomCard(
      title: 'Audit History',
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () {},
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Created'),
            subtitle: Text(DateFormat('MMM dd, yyyy HH:mm').format(quote.createdAt)),
          ),
          if (quote.respondedAt != null)
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text('Quotation Sent'),
              subtitle: Text(DateFormat('MMM dd, yyyy HH:mm').format(quote.respondedAt!)),
            ),
          if (quote.acceptedAt != null)
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Accepted'),
              subtitle: Text(DateFormat('MMM dd, yyyy HH:mm').format(quote.acceptedAt!)),
            ),
        ],
      ),
    );
  }

  Widget _buildValidityCard(Quote quote) {
    final isExpired = quote.validUntil!.isBefore(DateTime.now());
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isExpired ? Colors.red.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isExpired ? Colors.red : Colors.blue),
      ),
      child: Row(
        children: [
          Icon(isExpired ? Icons.warning : Icons.info, color: isExpired ? Colors.red : Colors.blue),
          const SizedBox(width: 12),
          Text(
            'Valid Until: ${DateFormat('MMM dd, yyyy').format(quote.validUntil!)}',
            style: TextStyle(color: isExpired ? Colors.red : Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showAcceptDialog(BuildContext context, Quote quote) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Quotation'),
        content: const Text('By accepting this quotation, you agree to the prices and terms listed. This will be processed for the final order.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              context.read<QuoteBloc>().add(AcceptQuoteEvent(quote.id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Confirm Acceptance'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context, Quote quote) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Quotation'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(labelText: 'Reason for rejection', hintText: 'Price is too high, etc.'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isNotEmpty) {
                context.read<QuoteBloc>().add(RejectQuoteEvent(quote.id, reasonController.text));
                Navigator.pop(context);
              }
            },
            child: const Text('Reject Quote'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
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
          Text('SAR ${value.toStringAsFixed(2)}', style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final QuoteStatus status;
  const _StatusBadge({required this.status});
  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(status.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: _getColor(),
    );
  }
  Color _getColor() {
    switch (status) {
      case QuoteStatus.pending: return Colors.orange;
      case QuoteStatus.underReview: return Colors.blue;
      case QuoteStatus.quoted: return Colors.purple;
      case QuoteStatus.accepted: return Colors.green;
      case QuoteStatus.rejected: return Colors.red;
      default: return Colors.grey;
    }
  }
}
