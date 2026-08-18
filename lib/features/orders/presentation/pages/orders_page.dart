import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/payment_status.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(const LoadOrders());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<OrderBloc>().add(const LoadOrders(refresh: true)),
          ),
        ],
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.status == OrderStatusState.loading && state.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _buildFilters(context, state),
              Expanded(
                child: state.orders.isEmpty
                    ? const Center(child: Text('No orders found.'))
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 900) {
                            return _buildDesktopTable(state.orders);
                          } else if (constraints.maxWidth > 600) {
                            return _buildTabletList(state.orders);
                          } else {
                            return _buildMobileCards(state.orders);
                          }
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilters(BuildContext context, OrderState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search by Order #, Quote #, Product, SKU...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    context.read<OrderBloc>().add(LoadOrders(query: value));
                  },
                ),
              ),
              const SizedBox(width: 16),
              _buildFilterDropdown<OrderStatus>(
                value: null,
                hint: 'Order Status',
                items: OrderStatus.values,
                onChanged: (val) {
                  context.read<OrderBloc>().add(LoadOrders(status: val));
                },
                itemLabel: (s) => s.name,
              ),
              const SizedBox(width: 16),
              _buildFilterDropdown<PaymentStatus>(
                value: null,
                hint: 'Payment Status',
                items: PaymentStatus.values,
                onChanged: (val) {
                  context.read<OrderBloc>().add(LoadOrders(paymentStatus: val));
                },
                itemLabel: (s) => s.name,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required Function(T?) onChanged,
    required String Function(T) itemLabel,
  }) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: [
            DropdownMenuItem<T>(value: null, child: Text('All $hint')),
            ...items.map((item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel(item)),
                )),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDesktopTable(List<Order> orders) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: CustomCard(
        title: 'Recent Orders',
        onTap: () {},
        child: DataTable(
          showCheckboxColumn: false,
          columns: const [
            DataColumn(label: Text('Order #')),
            DataColumn(label: Text('Quote #')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Customer')),
            DataColumn(label: Text('Total')),
            DataColumn(label: Text('Order Status')),
            DataColumn(label: Text('Payment Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: orders.map((order) => DataRow(
            onSelectChanged: (_) => context.go('/dashboard/orders/${order.id}'),
            cells: [
              DataCell(Text(order.orderNumber, style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(order.quoteNumber)),
              DataCell(Text(DateFormat('MMM dd, yyyy').format(order.createdAt))),
              DataCell(Text(order.customerName)),
              DataCell(Text('SAR ${order.total.toStringAsFixed(2)}')),
              DataCell(_StatusBadge(status: order.status)),
              DataCell(_PaymentBadge(status: order.paymentStatus)),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () => context.go('/dashboard/orders/${order.id}'),
                    tooltip: 'View Details',
                  ),
                  IconButton(
                    icon: const Icon(Icons.print),
                    onPressed: () => context.go('/dashboard/orders/${order.id}/invoice'),
                    tooltip: 'View Invoice',
                  ),
                ],
              )),
            ],
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildTabletList(List<Order> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return CustomCard(
          margin: const EdgeInsets.only(bottom: 12),
          onTap: () => context.go('/dashboard/orders/${order.id}'),
          child: ListTile(
            title: Text(order.orderNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${order.customerName} • ${DateFormat('MMM dd, yyyy').format(order.createdAt)}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('SAR ${order.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                _StatusBadge(status: order.status, isSmall: true),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileCards(List<Order> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return CustomCard(
          margin: const EdgeInsets.only(bottom: 16),
          onTap: () => context.go('/dashboard/orders/${order.id}'),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order.orderNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    _StatusBadge(status: order.status),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Customer: ${order.customerName}'),
                Text('Date: ${DateFormat('MMM dd, yyyy').format(order.createdAt)}'),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _PaymentBadge(status: order.paymentStatus),
                    Text('Total: SAR ${order.total.toStringAsFixed(2)}', 
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;
  final bool isSmall;
  const _StatusBadge({required this.status, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 8 : 12, vertical: isSmall ? 2 : 4),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getColor()),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: _getColor(), fontSize: isSmall ? 10 : 12, fontWeight: FontWeight.bold),
      ),
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

class _PaymentBadge extends StatelessWidget {
  final PaymentStatus status;
  const _PaymentBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 8, color: _getColor()),
        const SizedBox(width: 4),
        Text(status.name, style: TextStyle(color: _getColor(), fontWeight: FontWeight.w500)),
      ],
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
