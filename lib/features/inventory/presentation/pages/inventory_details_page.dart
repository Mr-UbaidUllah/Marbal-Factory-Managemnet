import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/inventory/domain/entities/inventory.dart';
import 'package:factory_management/features/inventory/domain/entities/stock_transaction.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_event.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_state.dart';
import 'package:factory_management/features/inventory/presentation/widgets/stock_operation_dialog.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class InventoryDetailsPage extends StatelessWidget {
  final String productId;

  const InventoryDetailsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<InventoryBloc>()..add(GetInventoryDetailsEvent(productId)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 18),
            onPressed: () => context.pop(),
          ),
          title: Text('Inventory Details', style: AppTextStyles.h2),
        ),
        body: BlocBuilder<InventoryBloc, InventoryState>(
          builder: (context, state) {
            if (state.status == InventoryStateStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final inventory = state.selectedInventory;
            if (inventory == null) {
              return Center(child: Text('Inventory record not found', style: AppTextStyles.h3));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, inventory),
                  const SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildStockInfo(inventory)),
                      const SizedBox(width: 32),
                      Expanded(child: _buildQuickActions(context, inventory)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildRecentHistory(context, productId, state.history),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Inventory inventory) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: FaIcon(FontAwesomeIcons.image, size: 32, color: AppColors.textSecondary)),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(inventory.productName, style: AppTextStyles.h1),
                    const SizedBox(width: 12),
                    _buildStatusBadge(inventory.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text('SKU: ${inventory.sku} | Category: ${inventory.categoryName}', 
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.push('/dashboard/products/${inventory.productId}'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.primary,
              elevation: 0,
            ),
            child: const Text('View Product'),
          ),
        ],
      ),
    );
  }

  Widget _buildStockInfo(Inventory inventory) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Stock Summary', style: AppTextStyles.h3),
          const SizedBox(height: 24),
          _buildInfoRow('Current Physical Stock', '${inventory.quantity} ${inventory.unit}', isBold: true),
          const Divider(height: 32),
          _buildInfoRow('Reserved for Orders', '${inventory.reservedQuantity} ${inventory.unit}'),
          const Divider(height: 32),
          _buildInfoRow('Available to Sell', '${inventory.availableQuantity} ${inventory.unit}', 
            valueColor: inventory.availableQuantity <= 0 ? AppColors.error : AppColors.success,
            isBold: true,
          ),
          const Divider(height: 32),
          _buildInfoRow('Minimum Stock Level', '${inventory.minimumStock} ${inventory.unit}'),
          const Divider(height: 32),
          _buildInfoRow('Maximum Stock Level', '${inventory.maximumStock} ${inventory.unit}'),
          const Divider(height: 32),
          _buildInfoRow('Last Updated', DateFormat('MMM dd, yyyy HH:mm').format(inventory.lastStockUpdate)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        Text(value, style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: valueColor ?? AppColors.textPrimary,
        )),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, Inventory inventory) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Stock Operations', style: AppTextStyles.h3),
          const SizedBox(height: 24),
          _actionButton(context, inventory, 'Add Stock', FontAwesomeIcons.plus as IconData, AppColors.success, StockOperationType.add),
          const SizedBox(height: 12),
          _actionButton(context, inventory, 'Remove Stock', FontAwesomeIcons.minus as IconData, AppColors.error, StockOperationType.remove),
          const SizedBox(height: 12),
          _actionButton(context, inventory, 'Adjust Stock', FontAwesomeIcons.sliders as IconData, AppColors.primary, StockOperationType.adjust),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, Inventory inventory, String label, IconData icon, Color color, StockOperationType type) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showStockOperation(context, inventory, type),
        icon: FaIcon(icon as FaIconData?, size: 14),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(InventoryStatus status) {
    Color color = status == InventoryStatus.inStock ? AppColors.success : (status == InventoryStatus.lowStock ? AppColors.warning : AppColors.error);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(status.name.toUpperCase(), style: AppTextStyles.label.copyWith(color: color, fontSize: 10)),
    );
  }

  void _showStockOperation(BuildContext context, Inventory inventory, StockOperationType type) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<InventoryBloc>(),
        child: StockOperationDialog(inventory: inventory, type: type),
      ),
    );
  }

  Widget _buildRecentHistory(BuildContext context, String productId, List<StockTransaction> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Transactions', style: AppTextStyles.h3),
            TextButton(
              onPressed: () => context.push('/dashboard/inventory/history?productId=$productId'),
              child: const Text('View All History'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          ),
          child: history.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text('No recent transactions found', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(AppColors.surface),
                    columns: [
                      DataColumn(label: Text('Date', style: AppTextStyles.label)),
                      DataColumn(label: Text('Type', style: AppTextStyles.label)),
                      DataColumn(label: Text('Qty', style: AppTextStyles.label)),
                      DataColumn(label: Text('Reason', style: AppTextStyles.label)),
                    ],
                    rows: history.take(5).map((t) => DataRow(
                      cells: [
                        DataCell(Text(DateFormat('MMM dd, HH:mm').format(t.createdAt), style: AppTextStyles.bodySmall)),
                        DataCell(_buildTypeBadge(t.type)),
                        DataCell(Text('${t.quantity}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold))),
                        DataCell(Text(t.reason, style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis)),
                      ],
                    )).toList(),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildTypeBadge(StockTransactionType type) {
    Color color;
    switch (type) {
      case StockTransactionType.stockIn: color = AppColors.success; break;
      case StockTransactionType.stockOut: color = AppColors.error; break;
      case StockTransactionType.adjustment: color = AppColors.primary; break;
      case StockTransactionType.transfer: color = Colors.orange; break;
      case StockTransactionType.returned: color = Colors.teal; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(type.name.toUpperCase(), style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }
}
