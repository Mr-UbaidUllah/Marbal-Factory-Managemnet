import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/inventory/domain/entities/inventory.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:factory_management/features/inventory/presentation/widgets/stock_operation_dialog.dart';
import 'package:intl/intl.dart';

class InventoryListTable extends StatelessWidget {
  final List<Inventory> inventory;

  const InventoryListTable({super.key, required this.inventory});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppColors.surface),
              dataRowMaxHeight: 70,
              columnSpacing: 24,
              columns: [
                DataColumn(label: Text('Product', style: AppTextStyles.label)),
                DataColumn(label: Text('SKU', style: AppTextStyles.label)),
                DataColumn(label: Text('Category', style: AppTextStyles.label)),
                DataColumn(label: Text('Stock', style: AppTextStyles.label)),
                DataColumn(label: Text('Available', style: AppTextStyles.label)),
                DataColumn(label: Text('Status', style: AppTextStyles.label)),
                DataColumn(label: Text('Last Updated', style: AppTextStyles.label)),
                DataColumn(label: Text('Actions', style: AppTextStyles.label)),
              ],
              rows: inventory.map((item) => _buildRow(context, item)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, Inventory item) {
    return DataRow(
      cells: [
        DataCell(
          InkWell(
            onTap: () => context.push('/dashboard/inventory/${item.productId}'),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: FaIcon(FontAwesomeIcons.image, size: 16, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.productName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    Text(item.unit, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ),
        DataCell(Text(item.sku, style: AppTextStyles.bodyMedium)),
        DataCell(Text(item.categoryName, style: AppTextStyles.bodyMedium)),
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${item.quantity}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              if (item.reservedQuantity > 0)
                Text('Res: ${item.reservedQuantity}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning)),
            ],
          ),
        ),
        DataCell(
          Text(
            '${item.availableQuantity}', 
            style: AppTextStyles.bodyMedium.copyWith(
              color: item.availableQuantity <= 0 ? AppColors.error : AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(_buildStatusBadge(item.status)),
        DataCell(Text(DateFormat('MMM dd, HH:mm').format(item.lastStockUpdate), style: AppTextStyles.bodySmall)),
        DataCell(
          Row(
            children: [
              IconButton(
                tooltip: 'Add Stock',
                icon: const FaIcon(FontAwesomeIcons.plus, size: 14, color: AppColors.success),
                onPressed: () => _showStockOperation(context, item, StockOperationType.add),
              ),
              IconButton(
                tooltip: 'Remove Stock',
                icon: const FaIcon(FontAwesomeIcons.minus, size: 14, color: AppColors.error),
                onPressed: () => _showStockOperation(context, item, StockOperationType.remove),
              ),
              IconButton(
                tooltip: 'Adjust Stock',
                icon: const FaIcon(FontAwesomeIcons.sliders, size: 14, color: AppColors.primary),
                onPressed: () => _showStockOperation(context, item, StockOperationType.adjust),
              ),
              IconButton(
                tooltip: 'History',
                icon: const FaIcon(FontAwesomeIcons.history, size: 14, color: AppColors.textSecondary),
                onPressed: () => context.push('/dashboard/inventory/history?productId=${item.productId}'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(InventoryStatus status) {
    Color color;
    switch (status) {
      case InventoryStatus.inStock:
        color = AppColors.success;
        break;
      case InventoryStatus.lowStock:
        color = AppColors.warning;
        break;
      case InventoryStatus.outOfStock:
        color = AppColors.error;
        break;
      case InventoryStatus.overstocked:
        color = Colors.purple;
        break;
      case InventoryStatus.loading:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
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
}
