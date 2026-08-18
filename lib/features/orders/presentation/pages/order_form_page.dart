import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
        if (state.selectedOrder != null && _addressController.text.isEmpty) {
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
          appBar: AppBar(
            title: Text('Edit Order: ${order.orderNumber}'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusBanner(order.status),
                  const SizedBox(height: 24),
                  const Text('Delivery Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Delivery Address *', border: OutlineInputBorder()),
                    enabled: !isReadOnly,
                    maxLines: 3,
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _deliveryNotesController,
                    decoration: const InputDecoration(labelText: 'Delivery Notes', border: OutlineInputBorder()),
                    enabled: !isReadOnly,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 32),
                  const Text('Order Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<PaymentMethod>(
                    value: _paymentMethod,
                    decoration: const InputDecoration(labelText: 'Payment Method', border: OutlineInputBorder()),
                    enabled: order.status == OrderStatus.pending,
                    items: PaymentMethod.values.map((m) => DropdownMenuItem(value: m, child: Text(m.name))).toList(),
                    onChanged: (val) => setState(() => _paymentMethod = val!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _orderNotesController,
                    decoration: const InputDecoration(labelText: 'Order Notes', border: OutlineInputBorder()),
                    enabled: !isReadOnly,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 40),
                  if (!isReadOnly)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state.status == OrderStatusState.submitting ? null : () => _saveOrder(order),
                        child: state.status == OrderStatusState.submitting 
                          ? const CircularProgressIndicator(color: Colors.white) 
                          : const Text('Save Changes'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBanner(OrderStatus status) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: Text(
        'Current Order Status: ${status.name}. Certain fields may be restricted based on this status.',
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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
