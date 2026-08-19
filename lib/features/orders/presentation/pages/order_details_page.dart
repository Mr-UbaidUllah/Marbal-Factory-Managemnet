import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/order_status_history.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/payment_status.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../widgets/order_status_badge.dart';
import '../widgets/payment_status_badge.dart';

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
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        final order = state.selectedOrder;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => context.pop(),
            ),
            title: Text(
              order != null ? 'Order ${order.orderNumber}' : 'Order Details',
              style: AppTextStyles.h3,
            ),
            actions: [
              if (order != null) ...[
                IconButton(
                  icon: const Icon(Icons.print_outlined, color: AppColors.textPrimary),
                  onPressed: () => context.go('/dashboard/orders/${order.id}/invoice'),
                  tooltip: 'Print Invoice',
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
          body: _buildBody(state),
          bottomNavigationBar: order != null ? _buildMobileActions(order) : null,
        );
      },
    );
  }

  Widget _buildBody(OrderState state) {
    if (state.status == OrderStatusState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final order = state.selectedOrder;
    if (order == null) return const Center(child: Text('Order not found.'));

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;
        final isTablet = constraints.maxWidth > 768 && constraints.maxWidth <= 1024;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(order),
                  const SizedBox(height: 24),
                  if (isDesktop || isTablet)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              _buildItemsSection(order),
                              const SizedBox(height: 24),
                              _buildTimelineSection(order),
                              const SizedBox(height: 24),
                              _buildHistorySection(state.history),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              _buildActionsCard(order),
                              const SizedBox(height: 24),
                              _buildSummaryCard(order),
                              const SizedBox(height: 24),
                              _buildDeliveryCard(order),
                              const SizedBox(height: 24),
                              _buildNotesCard(order),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildSummaryCard(order),
                        const SizedBox(height: 16),
                        _buildItemsSection(order),
                        const SizedBox(height: 16),
                        _buildTimelineSection(order),
                        const SizedBox(height: 16),
                        _buildDeliveryCard(order),
                        const SizedBox(height: 16),
                        _buildHistorySection(state.history),
                        const SizedBox(height: 16),
                        _buildNotesCard(order),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(Order order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(order.orderNumber, style: AppTextStyles.h2),
                    const SizedBox(width: 12),
                    OrderStatusBadge(status: order.status),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildHeaderInfo(Icons.calendar_today_outlined, 'Date: ${DateFormat('MMM dd, yyyy HH:mm').format(order.createdAt)}'),
                    GestureDetector(
                      onTap: () => context.go('/dashboard/quotations/${order.quoteId}'),
                      child: _buildHeaderInfo(Icons.description_outlined, 'Quote: ${order.quoteNumber}', color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (MediaQuery.of(context).size.width > 600)
            PaymentStatusBadge(status: order.paymentStatus),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo(IconData icon, String text, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color ?? AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.bodySmall.copyWith(
            color: color ?? AppColors.textSecondary,
            fontWeight: color != null ? FontWeight.w600 : null,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSection(Order order) {
    return CustomCard(
      title: 'Order Items',
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return DataTable(
              headingRowColor: WidgetStateProperty.all(AppColors.lightGray.withValues(alpha: 0.3)),
              columnSpacing: 24,
              columns: const [
                DataColumn(label: Text('Product')),
                DataColumn(label: Text('Qty'), numeric: true),
                DataColumn(label: Text('Price'), numeric: true),
                DataColumn(label: Text('Total'), numeric: true),
              ],
              rows: order.items.map((item) => DataRow(
                cells: [
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.productName, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                        Text('SKU: ${item.sku}', style: AppTextStyles.label.copyWith(fontSize: 10)),
                      ],
                    ),
                  ),
                  DataCell(Text('${item.quantity} ${item.unit}', style: AppTextStyles.bodySmall)),
                  DataCell(Text('SAR ${item.unitPrice.toStringAsFixed(2)}', style: AppTextStyles.bodySmall)),
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('SAR ${item.subtotal.toStringAsFixed(2)}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                        if (item.discount > 0)
                          Text('-SAR ${item.discount.toStringAsFixed(2)}', style: AppTextStyles.label.copyWith(color: AppColors.error, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              )).toList(),
            );
          } else {
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) => _buildMobileItemRow(order.items[index]),
            );
          }
        },
      ),
    );
  }

  Widget _buildMobileItemRow(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.productName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${item.quantity} ${item.unit} x SAR ${item.unitPrice.toStringAsFixed(2)}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              Text('SAR ${item.subtotal.toStringAsFixed(2)}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          if (item.discount > 0)
            Align(
              alignment: Alignment.centerRight,
              child: Text('-SAR ${item.discount.toStringAsFixed(2)} discount', style: AppTextStyles.label.copyWith(color: AppColors.error)),
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(Order order) {
    return CustomCard(
      title: 'Status Timeline',
      child: Column(
        children: [
          _buildTimelineItem('Order Placed', order.createdAt, true, true),
          _buildTimelineItem('Confirmed', order.confirmedAt, order.confirmedAt != null, true),
          _buildTimelineItem('Processing', order.processingAt, order.processingAt != null, true),
          _buildTimelineItem('Ready for Delivery', order.readyAt, order.readyAt != null, true),
          _buildTimelineItem('Completed', order.completedAt, order.completedAt != null, false),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String label, DateTime? date, bool isDone, bool showLine) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isDone ? AppColors.success : AppColors.lightGray,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: isDone ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
              ),
              if (showLine)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone ? AppColors.success : AppColors.lightGray,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.bodyMedium.copyWith(fontWeight: isDone ? FontWeight.w600 : FontWeight.w400, color: isDone ? AppColors.textPrimary : AppColors.textTertiary)),
                  if (date != null)
                    Text(DateFormat('MMM dd, yyyy HH:mm').format(date), style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(List<OrderStatusHistory> history) {
    if (history.isEmpty) return const SizedBox.shrink();

    return CustomCard(
      title: 'Status History',
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: history.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final h = history[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.history, size: 16, color: AppColors.textTertiary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                        children: [
                          TextSpan(text: '${h.previousStatus.name} ', style: const TextStyle(fontWeight: FontWeight.w600)),
                          const TextSpan(text: '→ '),
                          TextSpan(text: '${h.newStatus.name} ', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                        ],
                      ),
                    ),
                    Text(
                      'By ${h.changedBy} on ${DateFormat('MMM dd, HH:mm').format(h.createdAt)}',
                      style: AppTextStyles.label.copyWith(fontSize: 10),
                    ),
                    if (h.note != null && h.note!.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.lightGray.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(h.note!, style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic)),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(Order order) {
    return CustomCard(
      title: 'Financial Summary',
      child: Column(
        children: [
          _summaryRow('Subtotal', order.subtotal),
          _summaryRow('Discount', -order.discount, isNegative: true),
          _summaryRow('Tax', order.tax),
          _summaryRow('Delivery', order.deliveryCharges),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Grand Total', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              Text(
                'SAR ${order.total.toStringAsFixed(2)}',
                style: AppTextStyles.h3.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.payment, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('Method: ${order.paymentMethod.name}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                PaymentStatusBadge(status: order.paymentStatus, isSmall: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool isNegative = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          Text(
            '${isNegative ? '-' : ''}SAR ${value.abs().toStringAsFixed(2)}',
            style: AppTextStyles.bodySmall.copyWith(
              color: isNegative ? AppColors.error : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard(Order order) {
    return CustomCard(
      title: 'Delivery Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.person_outline, 'Customer', order.customerName),
          _buildInfoRow(Icons.phone_outlined, 'Phone', order.customerPhone),
          if (order.customerEmail != null) _buildInfoRow(Icons.email_outlined, 'Email', order.customerEmail!),
          const Divider(height: 24),
          _buildInfoRow(Icons.location_on_outlined, 'Address', order.deliveryAddress),
          if (order.deliveryNotes != null) ...[
            const SizedBox(height: 12),
            Text('Notes:', style: AppTextStyles.label),
            Text(order.deliveryNotes!, style: AppTextStyles.bodySmall),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.label.copyWith(fontSize: 10)),
                Text(value, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(Order order) {
    if (order.orderNotes == null || order.orderNotes!.isEmpty) return const SizedBox.shrink();
    return CustomCard(
      title: 'Order Notes',
      child: Text(order.orderNotes!, style: AppTextStyles.bodySmall),
    );
  }

  Widget _buildActionsCard(Order order) {
    if (order.status == OrderStatus.completed || order.status == OrderStatus.cancelled) {
      return const SizedBox.shrink();
    }

    return CustomCard(
      title: 'Actions',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () => _showStatusDialog(context, order),
            icon: const Icon(Icons.edit_notifications, size: 18),
            label: const Text('Update Status'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _showPaymentDialog(context, order),
            icon: const Icon(Icons.payment, size: 18),
            label: const Text('Update Payment'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => _showCancelDialog(context, order),
            icon: const Icon(Icons.cancel_outlined, size: 18),
            label: const Text('Cancel Order'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildMobileActions(Order order) {
    if (MediaQuery.of(context).size.width > 768) return null;
    if (order.status == OrderStatus.completed || order.status == OrderStatus.cancelled) return null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _showStatusDialog(context, order),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Change Status'),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => _showPaymentDialog(context, order),
            icon: const Icon(Icons.payment),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.lightGray,
              padding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => _showCancelDialog(context, order),
            icon: const Icon(Icons.more_vert),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.lightGray,
              padding: const EdgeInsets.all(14),
            ),
          ),
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
          title: Text('Update Status', style: AppTextStyles.h3),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current: ${order.status.name}', style: AppTextStyles.bodySmall),
              const SizedBox(height: 20),
              DropdownButtonFormField<OrderStatus>(
                initialValue: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'New Status',
                  border: OutlineInputBorder(),
                ),
                items: availableStatuses.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                onChanged: (val) => setDialogState(() => selectedStatus = val),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Internal Note (Optional)',
                  hintText: 'Reason for status change...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Update Status'),
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
          title: Text('Update Payment', style: AppTextStyles.h3),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<PaymentStatus>(
                  initialValue: selectedStatus,
                  decoration: const InputDecoration(labelText: 'Payment Status', border: OutlineInputBorder()),
                  items: PaymentStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                  onChanged: (val) => setDialogState(() => selectedStatus = val!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<PaymentMethod>(
                  initialValue: selectedMethod,
                  decoration: const InputDecoration(labelText: 'Payment Method', border: OutlineInputBorder()),
                  items: PaymentMethod.values.map((m) => DropdownMenuItem(value: m, child: Text(m.name))).toList(),
                  onChanged: (val) => setDialogState(() => selectedMethod = val!),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: refController,
                  decoration: const InputDecoration(labelText: 'Reference #', hintText: 'Bank transaction ID, etc.', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(labelText: 'Notes', border: OutlineInputBorder()),
                  maxLines: 2,
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
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Save Changes'),
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
        title: Text('Cancel Order', style: AppTextStyles.h3.copyWith(color: AppColors.error)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to cancel this order? This action cannot be undone.'),
            const SizedBox(height: 20),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for Cancellation *',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
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
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Confirm Cancellation'),
          ),
        ],
      ),
    );
  }
}
