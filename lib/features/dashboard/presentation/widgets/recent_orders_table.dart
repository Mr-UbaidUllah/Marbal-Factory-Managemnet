import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/shared/widgets/custom_card.dart';
import '../../../../features/orders/presentation/bloc/order_bloc.dart';
import '../../../../features/orders/presentation/bloc/order_event.dart';
import '../../../../features/orders/presentation/bloc/order_state.dart';
import '../../../../features/orders/domain/entities/order.dart';
import '../../../../features/orders/domain/entities/order_status.dart';

class RecentOrdersTable extends StatelessWidget {
  const RecentOrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        final orders = state.orders.take(5).toList();

        return CustomCard(
          margin: const EdgeInsets.only(bottom: 16),
          onTap: () {},
          title: '',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Orders', style: AppTextStyles.h3),
                  TextButton(
                    onPressed: () => context.go('/dashboard/orders'),
                    child: Text(
                      'View All',
                      style: AppTextStyles.label.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (state.status == OrderStatusState.loading && orders.isEmpty)
                const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()))
              else if (orders.isEmpty)
                const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('No recent orders.')))
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      AppColors.lightGray.withOpacity(0.5),
                    ),
                    columnSpacing: 40,
                    dividerThickness: 0.5,
                    showCheckboxColumn: false,
                    columns: [
                      _buildColumn('Order #'),
                      _buildColumn('Customer'),
                      _buildColumn('Status'),
                      _buildColumn('Total'),
                      _buildColumn('Date'),
                    ],
                    rows: orders.map((order) => _buildRow(context, order)).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  DataColumn _buildColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, Order order) {
    return DataRow(
      onSelectChanged: (_) => context.go('/dashboard/orders/${order.id}'),
      cells: [
        DataCell(
          Text(
            order.orderNumber,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DataCell(Text(order.customerName, style: AppTextStyles.bodySmall)),
        DataCell(_buildStatusBadge(order.status)),
        DataCell(
          Text('SAR ${order.total.toStringAsFixed(2)}', style: AppTextStyles.price.copyWith(fontSize: 14)),
        ),
        DataCell(Text(DateFormat('MMM dd, yyyy').format(order.createdAt), style: AppTextStyles.bodySmall)),
      ],
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color color;
    switch (status) {
      case OrderStatus.completed:
        color = AppColors.success;
        break;
      case OrderStatus.pending:
        color = AppColors.warning;
        break;
      case OrderStatus.confirmed:
      case OrderStatus.processing:
      case OrderStatus.ready:
        color = AppColors.info;
        break;
      case OrderStatus.cancelled:
        color = AppColors.error;
        break;
      default:
        color = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.name,
        style: AppTextStyles.label.copyWith(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
