import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/entities/payment_status.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';

class OrderInvoicePage extends StatefulWidget {
  final String orderId;

  const OrderInvoicePage({super.key, required this.orderId});

  @override
  State<OrderInvoicePage> createState() => _OrderInvoicePageState();
}

class _OrderInvoicePageState extends State<OrderInvoicePage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(GetOrderDetail(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // Future PDF export implementation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Print functionality will be available in a future update.')),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.status == OrderStatusState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final order = state.selectedOrder;
          if (order == null) return const Center(child: Text('Order not found.'));

          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              margin: const EdgeInsets.all(24),
              child: Card(
                elevation: 4,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const Divider(height: 40, thickness: 2),
                      _buildOrderInfo(order),
                      const SizedBox(height: 32),
                      _buildItemsTable(order.items),
                      const SizedBox(height: 32),
                      _buildTotals(order),
                      const Divider(height: 40),
                      _buildFooter(order),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'ALAM MARBLE & GRANITE FACTORY',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Industrial Area, Riyadh, KSA'),
            Text('Phone: +966 11 123 4567'),
            Text('Email: info@alammarble.com'),
            Text('VAT #: 300000000000003'),
          ],
        ),
        const Icon(Icons.factory, size: 80, color: Colors.grey),
      ],
    );
  }

  Widget _buildOrderInfo(Order order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('BILL TO:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(order.customerName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(order.customerPhone),
            if (order.customerEmail != null) Text(order.customerEmail!),
            const SizedBox(height: 8),
            const Text('DELIVERY ADDRESS:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              width: 250,
              child: Text(order.deliveryAddress),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('INVOICE #: ${order.orderNumber.replaceFirst('ORD', 'INV')}', 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Order Date: ${DateFormat('dd MMM yyyy').format(order.createdAt)}'),
            Text('Quote Reference: ${order.quoteNumber}'),
            const SizedBox(height: 16),
            _PaymentStatusBox(status: order.paymentStatus),
          ],
        ),
      ],
    );
  }

  Widget _buildItemsTable(List<OrderItem> items) {
    return Table(
      border: TableBorder(
        bottom: BorderSide(color: Colors.grey.shade300),
        horizontalInside: BorderSide(color: Colors.grey.shade100),
      ),
      columnWidths: const {
        0: FlexColumnWidth(4),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1.5),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(1.5),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children: const [
            Padding(padding: EdgeInsets.all(12), child: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(12), child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(12), child: Text('Unit Price', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(12), child: Text('Discount', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(12), child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        ...items.map((item) => TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('SKU: ${item.sku}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.all(12), child: Text('${item.quantity} ${item.unit}')),
                Padding(padding: const EdgeInsets.all(12), child: Text(item.unitPrice.toStringAsFixed(2))),
                Padding(padding: const EdgeInsets.all(12), child: Text(item.discount.toStringAsFixed(2))),
                Padding(padding: const EdgeInsets.all(12), child: Text(item.subtotal.toStringAsFixed(2))),
              ],
            )),
      ],
    );
  }

  Widget _buildTotals(Order order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 300,
          child: Column(
            children: [
              _totalRow('Subtotal', order.subtotal),
              _totalRow('Discount', -order.discount),
              _totalRow('Tax (15%)', order.tax),
              _totalRow('Delivery Charges', order.deliveryCharges),
              const Divider(thickness: 2),
              _totalRow('Grand Total', order.total, isBold: true, fontSize: 18),
              const SizedBox(height: 8),
              Text('Currency: Saudi Riyal (SAR)', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _totalRow(String label, double value, {bool isBold = false, double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: fontSize)),
          Text(value.toStringAsFixed(2), 
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: fontSize)),
        ],
      ),
    );
  }

  Widget _buildFooter(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Terms & Conditions:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('1. Goods once sold will not be taken back.'),
        const Text('2. This is a computer-generated invoice.'),
        const SizedBox(height: 24),
        if (order.orderNotes != null) ...[
          const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(order.orderNotes!),
          const SizedBox(height: 24),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 40),
                Container(width: 150, height: 1, color: Colors.black),
                const Text('Customer Signature'),
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 40),
                Container(width: 150, height: 1, color: Colors.black),
                const Text('Authorized Signatory'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _PaymentStatusBox extends StatelessWidget {
  final PaymentStatus status;
  const _PaymentStatusBox({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.1),
        border: Border.all(color: _getColor(), width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: _getColor(), fontWeight: FontWeight.bold, fontSize: 16),
      ),
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
