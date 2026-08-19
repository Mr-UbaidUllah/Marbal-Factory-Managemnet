import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/shared/widgets/custom_card.dart';
import 'package:factory_management/features/orders/presentation/bloc/order_bloc.dart';
import 'package:factory_management/features/orders/presentation/bloc/order_state.dart';
import 'package:factory_management/features/orders/domain/entities/order.dart';
import 'package:factory_management/features/orders/presentation/widgets/order_status_badge.dart';

class RecentOrdersTable extends StatelessWidget {
  const RecentOrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        // Show only the top 5 recent orders for the dashboard preview
        final orders = state.orders.take(5).toList();

        return CustomCard(
          margin: const EdgeInsets.only(bottom: 16),
          onTap: () {}, // Interaction handled by rows
          title: '',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Orders', style: AppTextStyles.h3),
                    TextButton.icon(
                      onPressed: () => context.go('/dashboard/orders'),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: Text(
                        'View All',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (state.status == OrderStatusState.loading && orders.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (orders.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textTertiary.withOpacity(0.5)),
                        const SizedBox(height: 12),
                        Text(
                          'No recent orders found',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                _buildTable(context, orders),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTable(BuildContext context, List<Order> orders) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: AppColors.divider,
          dataTableTheme: DataTableThemeData(
            headingTextStyle: AppTextStyles.label.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
              fontSize: 11,
            ),
            dataTextStyle: AppTextStyles.bodySmall,
          ),
        ),
        child: DataTable(
          headingRowHeight: 44,
          dataRowMinHeight: 56,
          dataRowMaxHeight: 64,
          headingRowColor: WidgetStateProperty.all(AppColors.background.withOpacity(0.5)),
          columnSpacing: 24,
          showCheckboxColumn: false,
          horizontalMargin: 12,
          columns: const [
            DataColumn(label: Text('ORDER #')),
            DataColumn(label: Text('CUSTOMER')),
            DataColumn(label: Text('STATUS')),
            DataColumn(label: Text('TOTAL'), numeric: true),
            DataColumn(label: Text('DATE')),
            DataColumn(label: Text('')),
          ],
          rows: orders.map((order) => _buildRow(context, order)).toList(),
        ),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, Order order) {
    return DataRow(
      onSelectChanged: (_) => context.go('/dashboard/orders/${order.id}'),
      color: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.hovered)) {
          return AppColors.primary.withOpacity(0.04);
        }
        return null;
      }),
      cells: [
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order.orderNumber,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 160,
            child: Text(
              order.customerName,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(OrderStatusBadge(status: order.status, isSmall: true)),
        DataCell(
          Text(
            'SAR ${order.total.toStringAsFixed(2)}',
            style: AppTextStyles.price.copyWith(
              fontSize: 13,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            DateFormat('MMM dd, yyyy').format(order.createdAt),
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.textTertiary.withOpacity(0.7)),
          ),
        ),
      ],
    );
  }
}
