import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/order_status_history.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/payment_status.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(GetOrderDetail(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: [
          BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              final order = state.selectedOrder;
              if (order == null) return const SizedBox.shrink();

              return Row(
                children: [
                  if (order.status != OrderStatus.completed && order.status != OrderStatus.cancelled) ...[
                    ElevatedButton.icon(
                      onPressed: () => _showStatusDialog(context, order),
                      icon: const Icon(Icons.edit_notifications),
                      label: const Text('Update Status'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _showPaymentDialog(context, order),
                      icon: const Icon(Icons.payment),
                      label: const Text('Update Payment'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => _showCancelDialog(context, order),
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel Order'),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  ],
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.print),
                    onPressed: () => context.go('/dashboard/orders/${order.id}/invoice'),
                    tooltip: 'Print Invoice',
                  ),
                  const SizedBox(width: 16),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.status == OrderStatusState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final order = state.selectedOrder;
          if (order == null) return const Center(child: Text('Order not found.'));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(order),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildItemsList(order),
                          const SizedBox(height: 24),
                          _buildTimeline(order),
                          const SizedBox(height: 24),
                          _buildHistory(state.history),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildPaymentDeliveryCard(order),
                          const SizedBox(height: 24),
                          _buildSummary(order),
                          const SizedBox(height: 24),
                          _buildNotesCard(order),
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
    );
  }

  Widget _buildHeader(Order order) {
    return CustomCard(
      title: 'Order Information',
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.orderNumber, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => context.go('/dashboard/quotations/${order.quoteId}'),
                  child: Text(
                    'From Quote: ${order.quoteNumber}',
                    style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
                Text('Created: ${DateFormat('MMM dd, yyyy HH:mm').format(order.createdAt)}'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _StatusBadge(status: order.status),
                const SizedBox(height: 8),
                _PaymentStatusBadge(status: order.paymentStatus),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(Order order) {
    return CustomCard(
      title: 'Order Items',
      onTap: () {},
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: order.items.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final item = order.items[index];
          return ListTile(
            title: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('SKU: ${item.sku} • Category: ${item.categoryName}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${item.quantity} ${item.unit} x SAR ${item.unitPrice.toStringAsFixed(2)}'),
                if (item.discount > 0)
                  Text('- SAR ${item.discount.toStringAsFixed(2)} discount', style: const TextStyle(color: Colors.red, fontSize: 12)),
                Text('SAR ${item.subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeline(Order order) {
    return CustomCard(
      title: 'Order Timeline',
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _TimelineItem(label: 'Pending', date: order.createdAt, isActive: true),
            _TimelineItem(label: 'Confirmed', date: order.confirmedAt, isActive: order.confirmedAt != null),
            _TimelineItem(label: 'Processing', date: order.processingAt, isActive: order.processingAt != null),
            _TimelineItem(label: 'Ready', date: order.readyAt, isActive: order.readyAt != null),
            _TimelineItem(label: 'Completed', date: order.completedAt, isActive: order.completedAt != null),
          ],
        ),
      ),
    );
  }

  Widget _buildHistory(List<OrderStatusHistory> history) {
    return CustomCard(
      title: 'Status History',
      onTap: () {},
      child: history.isEmpty
          ? const Padding(padding: EdgeInsets.all(16.0), child: Text('No history available'))
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final h = history[index];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text('${h.previousStatus.name} → ${h.newStatus.name}'),
                  subtitle: Text('${h.changedBy} on ${DateFormat('MMM dd, yyyy HH:mm').format(h.createdAt)}'),
                  trailing: h.note != null ? IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: () => _showNoteDialog(context, h.note!),
                  ) : null,
                );
              },
            ),
    );
  }

  Widget _buildPaymentDeliveryCard(Order order) {
    return CustomCard(
      title: 'Payment & Delivery',
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Customer Contact', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(order.customerName),
          Text(order.customerPhone),
          if (order.customerEmail != null) Text(order.customerEmail!),
          const Divider(),
          const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(order.paymentMethod.name),
          if (order.paymentReference != null) Text('Ref: ${order.paymentReference}'),
          const Divider(),
          const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(order.deliveryAddress),
          if (order.deliveryNotes != null) ...[
            const SizedBox(height: 8),
            const Text('Delivery Notes:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Text(order.deliveryNotes!),
          ],
        ],
      ),
    );
  }

  Widget _buildSummary(Order order) {
    return CustomCard(
      title: 'Financial Summary',
      onTap: () {},
      child: Column(
        children: [
          _summaryRow('Subtotal', order.subtotal),
          _summaryRow('Discount', -order.discount, color: Colors.red),
          _summaryRow('Tax', order.tax),
          _summaryRow('Delivery Charges', order.deliveryCharges),
          const Divider(thickness: 2),
          _summaryRow('Grand Total', order.total, isBold: true, color: Colors.green),
        ],
      ),
    );
  }

  Widget _buildNotesCard(Order order) {
    return CustomCard(
      title: 'Order Notes',
      onTap: () {},
      child: Text(order.orderNotes ?? 'No additional notes.'),
    );
  }

  Widget _summaryRow(String label, double value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text('SAR ${value.toStringAsFixed(2)}', 
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color)),
        ],
      ),
    );
  }

  void _showStatusDialog(BuildContext context, Order order) {
    final List<OrderStatus> availableStatuses = OrderStatus.values
        .where((s) => order.status.canTransitionTo(s))
        .toList();

    if (availableStatuses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No further status transitions available.')));
      return;
    }

    OrderStatus? selectedStatus = availableStatuses.first;
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Update Order Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current Status: ${order.status.name}'),
              const SizedBox(height: 16),
              DropdownButtonFormField<OrderStatus>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: 'New Status'),
                items: availableStatuses.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                onChanged: (val) => setDialogState(() => selectedStatus = val),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'Note (Optional)', hintText: 'Reason for change...'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (selectedStatus != null) {
                  context.read<OrderBloc>().add(ChangeOrderStatusEvent(order.id, selectedStatus!, note: noteController.text));
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, Order order) {
    PaymentStatus selectedStatus = order.paymentStatus;
    PaymentMethod selectedMethod = order.paymentMethod;
    final refController = TextEditingController(text: order.paymentReference);
    final noteController = TextEditingController(text: order.paymentNotes);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Update Payment Information'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<PaymentStatus>(
                  value: selectedStatus,
                  decoration: const InputDecoration(labelText: 'Payment Status'),
                  items: PaymentStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                  onChanged: (val) => setDialogState(() => selectedStatus = val!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<PaymentMethod>(
                  value: selectedMethod,
                  decoration: const InputDecoration(labelText: 'Payment Method'),
                  items: PaymentMethod.values.map((m) => DropdownMenuItem(value: m, child: Text(m.name))).toList(),
                  onChanged: (val) => setDialogState(() => selectedMethod = val!),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: refController,
                  decoration: const InputDecoration(labelText: 'Reference #', hintText: 'Bank transaction ID, etc.'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                context.read<OrderBloc>().add(UpdateOrderPaymentEvent(
                  orderId: order.id,
                  paymentStatus: selectedStatus,
                  paymentMethod: selectedMethod,
                  reference: refController.text,
                  notes: noteController.text,
                ));
                Navigator.pop(context);
              },
              child: const Text('Update Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Order order) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to cancel this order? This action cannot be undone.'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: 'Reason for Cancellation *'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Go Back')),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isNotEmpty) {
                context.read<OrderBloc>().add(CancelOrderEvent(order.id, reasonController.text));
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Confirm Cancellation'),
          ),
        ],
      ),
    );
  }

  void _showNoteDialog(BuildContext context, String note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('History Note'),
        content: Text(note),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;
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
      case OrderStatus.pending: return Colors.orange;
      case OrderStatus.confirmed: return Colors.blue;
      case OrderStatus.processing: return Colors.indigo;
      case OrderStatus.ready: return Colors.teal;
      case OrderStatus.completed: return Colors.green;
      case OrderStatus.cancelled: return Colors.red;
    }
  }
}

class _PaymentStatusBadge extends StatelessWidget {
  final PaymentStatus status;
  const _PaymentStatusBadge({required this.status});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _getColor()),
      ),
      child: Text(status.name, style: TextStyle(color: _getColor(), fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
  Color _getColor() {
    switch (status) {
      case PaymentStatus.pending: return Colors.orange;
      case PaymentStatus.partial: return Colors.blue;
      case PaymentStatus.paid: return Colors.green;
      case PaymentStatus.refunded: return Colors.red;
    }
  }
}

class _TimelineItem extends StatelessWidget {
  final String label;
  final DateTime? date;
  final bool isActive;
  const _TimelineItem({required this.label, this.date, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(isActive ? Icons.check_circle : Icons.radio_button_unchecked, color: isActive ? Colors.green : Colors.grey),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontWeight: isActive ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
        if (date != null)
          Text(DateFormat('MMM dd').format(date!), style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
