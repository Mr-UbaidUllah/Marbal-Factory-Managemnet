import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/shared/widgets/custom_card.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/payment_method.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';

class OrderFormPage extends StatefulWidget {
  final String orderId;

  const OrderFormPage({super.key, required this.orderId});

  @override
  State<OrderFormPage> createState() => _OrderFormPageState();
}

class _OrderFormPageState extends State<OrderFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _addressController;
  late TextEditingController _deliveryNotesController;
  late TextEditingController _orderNotesController;
  late PaymentMethod _paymentMethod;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _deliveryNotesController = TextEditingController();
    _orderNotesController = TextEditingController();
    _paymentMethod = PaymentMethod.cash;
    
    final state = context.read<OrderBloc>().state;
    final order = state.selectedOrder;
    
    if (order != null && order.id == widget.orderId) {
      _initFields(order);
    } else {
      context.read<OrderBloc>().add(GetOrderDetail(widget.orderId));
    }
  }

  void _initFields(Order order) {
    _addressController.text = order.deliveryAddress;
    _deliveryNotesController.text = order.deliveryNotes ?? '';
    _orderNotesController.text = order.orderNotes ?? '';
    _paymentMethod = order.paymentMethod;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _deliveryNotesController.dispose();
    _orderNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state.status == OrderStatusState.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order updated successfully')),
          );
          context.pop();
        }
        if (state.selectedOrder != null && 
            state.selectedOrder!.id == widget.orderId && 
            _addressController.text.isEmpty) {
          _initFields(state.selectedOrder!);
        }
      },
      builder: (context, state) {
        final order = state.selectedOrder;
        
        if (state.status == OrderStatusState.loading && order == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        if (order == null) {
          return const Scaffold(body: Center(child: Text('Order not found')));
        }

        final bool isReadOnly = order.status == OrderStatus.ready || 
                               order.status == OrderStatus.completed || 
                               order.status == OrderStatus.cancelled;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: BackButton(color: AppColors.textPrimary),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Edit Order', style: AppTextStyles.h3),
                Text(order.orderNumber, style: AppTextStyles.label.copyWith(fontSize: 10)),
              ],
            ),
          ),
          body: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusBanner(order.status),
                      const SizedBox(height: 24),
                      
                      CustomCard(

                        title: 'Delivery Details',
                        margin: const EdgeInsets.only(bottom: 24), onTap: () {  },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Customer: ${order.customerName}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                labelText: 'Delivery Address *',
                                border: OutlineInputBorder(),
                                alignLabelWithHint: true,
                              ),
                              enabled: !isReadOnly,
                              maxLines: 3,
                              style: AppTextStyles.bodyMedium,
                              validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _deliveryNotesController,
                              decoration: const InputDecoration(
                                labelText: 'Delivery Notes',
                                border: OutlineInputBorder(),
                                hintText: 'Gate code, delivery times, etc.',
                              ),
                              enabled: !isReadOnly,
                              maxLines: 2,
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      CustomCard(
                        title: 'Order Configuration',
                        margin: const EdgeInsets.only(bottom: 24), onTap: () {  },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<PaymentMethod>(
                              value: _paymentMethod,
                              decoration: const InputDecoration(
                                labelText: 'Payment Method',
                                border: OutlineInputBorder(),
                                helperText: 'Method can only be changed while order is pending.',
                              ),
                              items: PaymentMethod.values.map((m) => DropdownMenuItem(
                                value: m,
                                child: Text(m.name, style: AppTextStyles.bodyMedium),
                              )).toList(),
                              onChanged: order.status == OrderStatus.pending
                                  ? (val) => setState(() => _paymentMethod = val!)
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _orderNotesController,
                              decoration: const InputDecoration(
                                labelText: 'Internal Order Notes',
                                border: OutlineInputBorder(),
                                hintText: 'Notes for internal factory use...',
                              ),
                              enabled: !isReadOnly,
                              maxLines: 3,
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      if (!isReadOnly)
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: state.status == OrderStatusState.submitting ? null : () => _saveOrder(order),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            child: state.status == OrderStatusState.submitting 
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                              : Text('Update Order Details', style: AppTextStyles.button),
                          ),
                        ),
                        
                      if (isReadOnly)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.lightGray,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.lock_outline, size: 20, color: AppColors.textSecondary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'This order is in ${order.status.name} state and can no longer be edited.',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBanner(OrderStatus status) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.info.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.info, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Current Status: ${status.name}. Field availability is restricted based on status workflow.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.info, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _saveOrder(Order order) {
    if (_formKey.currentState!.validate()) {
      final updatedOrder = order.copyWith(
        deliveryAddress: _addressController.text,
        deliveryNotes: _deliveryNotesController.text,
        orderNotes: _orderNotesController.text,
        paymentMethod: _paymentMethod,
      );
      context.read<OrderBloc>().add(UpdateOrderEvent(updatedOrder));
    }
  }
}
