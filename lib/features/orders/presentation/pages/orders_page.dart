import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/payment_status.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../widgets/order_status_badge.dart';
import '../widgets/payment_status_badge.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final TextEditingController _searchController = TextEditingController();
  OrderStatus? _selectedStatus;
  PaymentStatus? _selectedPaymentStatus;

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

  void _onSearchChanged(String value) {
    context.read<OrderBloc>().add(LoadOrders(
      query: value,
      status: _selectedStatus,
      paymentStatus: _selectedPaymentStatus,
    ));
  }

  void _onStatusChanged(OrderStatus? status) {
    setState(() => _selectedStatus = status);
    context.read<OrderBloc>().add(LoadOrders(
      query: _searchController.text,
      status: status,
      paymentStatus: _selectedPaymentStatus,
    ));
  }

  void _onPaymentStatusChanged(PaymentStatus? status) {
    setState(() => _selectedPaymentStatus = status);
    context.read<OrderBloc>().add(LoadOrders(
      query: _searchController.text,
      status: _selectedStatus,
      paymentStatus: status,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Order Management', style: AppTextStyles.h2),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: () => context.read<OrderBloc>().add(const LoadOrders(refresh: true)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildHeader(context, state),
              Expanded(
                child: _buildContent(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, OrderState state) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          if (isMobile) ...[
            _buildSearchField(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatusDropdown()),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showFilterBottomSheet(context),
                  icon: const Icon(Icons.filter_list),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.lightGray,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ] else
            Row(
              children: [
                Expanded(flex: 2, child: _buildSearchField()),
                const SizedBox(width: 16),
                Expanded(child: _buildStatusDropdown()),
                const SizedBox(width: 16),
                Expanded(child: _buildPaymentDropdown()),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Search orders...',
        prefixIcon: const Icon(Icons.search, size: 20),
        filled: true,
        fillColor: AppColors.lightGray.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return _buildDropdown<OrderStatus>(
      value: _selectedStatus,
      hint: 'All Statuses',
      items: OrderStatus.values,
      onChanged: _onStatusChanged,
      itemLabel: (s) => s.name,
    );
  }

  Widget _buildPaymentDropdown() {
    return _buildDropdown<PaymentStatus>(
      value: _selectedPaymentStatus,
      hint: 'All Payments',
      items: PaymentStatus.values,
      onChanged: _onPaymentStatusChanged,
      itemLabel: (s) => s.name,
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required Function(T?) onChanged,
    required String Function(T) itemLabel,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint, style: AppTextStyles.bodySmall),
          isExpanded: true,
          items: [
            DropdownMenuItem<T>(value: null, child: Text('All $hint', style: AppTextStyles.bodySmall)),
            ...items.map((item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel(item), style: AppTextStyles.bodySmall),
                )),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filters', style: AppTextStyles.h3),
            const SizedBox(height: 20),
            Text('Payment Status', style: AppTextStyles.label),
            const SizedBox(height: 8),
            _buildPaymentDropdown(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, OrderState state) {
    if (state.status == OrderStatusState.loading && state.orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.orders.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1024) {
          return _buildDesktopTable(state.orders);
        } else if (constraints.maxWidth > 768) {
          return _buildTabletTable(state.orders);
        } else {
          return _buildMobileCards(state.orders);
        }
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text('No orders found', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () {
              _searchController.clear();
              _onStatusChanged(null);
              _onPaymentStatusChanged(null);
            },
            child: const Text('Clear All Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTable(List<Order> orders) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: CustomCard(
        title: '',
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.only(bottom: 24), onTap: () {  },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.lightGray.withOpacity(0.5)),
            showCheckboxColumn: false,
            horizontalMargin: 24,
            columnSpacing: 24,
            columns: [
              _buildDataColumn('Order #'),
              _buildDataColumn('Quote #'),
              _buildDataColumn('Date'),
              _buildDataColumn('Customer'),
              _buildDataColumn('Total'),
              _buildDataColumn('Status'),
              _buildDataColumn('Payment'),
              _buildDataColumn('Actions', numeric: true),
            ],
            rows: orders.map((order) => DataRow(
              onSelectChanged: (_) => context.go('/dashboard/orders/${order.id}'),
              cells: [
                DataCell(Text(order.orderNumber, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary))),
                DataCell(Text(order.quoteNumber, style: AppTextStyles.bodySmall)),
                DataCell(Text(DateFormat('MMM dd, yyyy').format(order.createdAt), style: AppTextStyles.bodySmall)),
                DataCell(Text(order.customerName, style: AppTextStyles.bodySmall)),
                DataCell(Text('SAR ${order.total.toStringAsFixed(2)}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600))),
                DataCell(OrderStatusBadge(status: order.status, isSmall: true)),
                DataCell(PaymentStatusBadge(status: order.paymentStatus, isSmall: true)),
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility_outlined, size: 20),
                        onPressed: () => context.go('/dashboard/orders/${order.id}'),
                        tooltip: 'View Details',
                      ),
                      IconButton(
                        icon: const Icon(Icons.print_outlined, size: 20),
                        onPressed: () => context.go('/dashboard/orders/${order.id}/invoice'),
                        tooltip: 'View Invoice',
                      ),
                    ],
                  ),
                ),
              ],
            )).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletTable(List<Order> orders) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: CustomCard(
        title: '',
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.only(bottom: 24), onTap: () {  },
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.lightGray.withOpacity(0.5)),
          showCheckboxColumn: false,
          horizontalMargin: 16,
          columnSpacing: 16,
          columns: [
            _buildDataColumn('Order #'),
            _buildDataColumn('Customer'),
            _buildDataColumn('Total'),
            _buildDataColumn('Status'),
            _buildDataColumn('Actions', numeric: true),
          ],
          rows: orders.map((order) => DataRow(
            onSelectChanged: (_) => context.go('/dashboard/orders/${order.id}'),
            cells: [
              DataCell(Text(order.orderNumber, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600))),
              DataCell(Text(order.customerName, style: AppTextStyles.bodySmall)),
              DataCell(Text('SAR ${order.total.toStringAsFixed(2)}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600))),
              DataCell(OrderStatusBadge(status: order.status, isSmall: true)),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () => context.go('/dashboard/orders/${order.id}'),
                ),
              ),
            ],
          )).toList(),
        ),
      ),
    );
  }

  DataColumn _buildDataColumn(String label, {bool numeric = false}) {
    return DataColumn(
      numeric: numeric,
      label: Text(label, style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
    );
  }

  Widget _buildMobileCards(List<Order> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => context.go('/dashboard/orders/${order.id}'),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order.orderNumber, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      OrderStatusBadge(status: order.status, isSmall: true),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('MMM dd, yyyy').format(order.createdAt),
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(order.customerName, style: AppTextStyles.bodySmall),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PaymentStatusBadge(status: order.paymentStatus, isSmall: true),
                      Text(
                        'SAR ${order.total.toStringAsFixed(2)}',
                        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
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
}
