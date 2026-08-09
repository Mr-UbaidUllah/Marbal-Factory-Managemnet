import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/inventory/domain/entities/stock_transaction.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_event.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_state.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/inventory.dart';

class InventoryHistoryPage extends StatelessWidget {
  final String? productId;

  const InventoryHistoryPage({super.key, this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<InventoryBloc>()..add(LoadStockHistory(productId: productId)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 18),
            onPressed: () => context.pop(),
          ),
          title: Text('Stock History', style: AppTextStyles.h2),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productId != null ? 'Transaction History for Product' : 'Global Stock Transactions',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<InventoryBloc, InventoryState>(
                  builder: (context, state) {
                    if (state.status == InventoryStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.history.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(FontAwesomeIcons.clockRotateLeft, size: 48, color: AppColors.textSecondary),
                            const SizedBox(height: 16),
                            Text('No transactions found', style: AppTextStyles.h3),
                          ],
                        ),
                      );
                    }

                    return _buildHistoryTable(state.history);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryTable(List<StockTransaction> history) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.surface),
            columns: [
              DataColumn(label: Text('Date', style: AppTextStyles.label)),
              DataColumn(label: Text('Product', style: AppTextStyles.label)),
              DataColumn(label: Text('Type', style: AppTextStyles.label)),
              DataColumn(label: Text('Quantity', style: AppTextStyles.label)),
              DataColumn(label: Text('Previous', style: AppTextStyles.label)),
              DataColumn(label: Text('New', style: AppTextStyles.label)),
              DataColumn(label: Text('Reason', style: AppTextStyles.label)),
              DataColumn(label: Text('User', style: AppTextStyles.label)),
            ],
            rows: history.map((t) => _buildRow(t)).toList(),
          ),
        ),
      ),
    );
  }

  DataRow _buildRow(StockTransaction t) {
    return DataRow(
      cells: [
        DataCell(Text(DateFormat('MMM dd, yyyy HH:mm').format(t.createdAt), style: AppTextStyles.bodySmall)),
        DataCell(Text(t.productName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold))),
        DataCell(_buildTypeBadge(t.type)),
        DataCell(Text('${t.quantity}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold))),
        DataCell(Text('${t.previousQuantity}', style: AppTextStyles.bodySmall)),
        DataCell(Text('${t.newQuantity}', style: AppTextStyles.bodyMedium)),
        DataCell(Text(t.reason, style: AppTextStyles.bodySmall)),
        DataCell(Text(t.performedBy, style: AppTextStyles.bodySmall)),
      ],
    );
  }

  Widget _buildTypeBadge(StockTransactionType type) {
    Color color;
    switch (type) {
      case StockTransactionType.stockIn:
        color = AppColors.success;
        break;
      case StockTransactionType.stockOut:
        color = AppColors.error;
        break;
      case StockTransactionType.adjustment:
        color = AppColors.primary;
        break;
      case StockTransactionType.transfer:
        color = Colors.orange;
        break;
      case StockTransactionType.returned:
        color = Colors.teal;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        type.name.toUpperCase(),
        style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }
}
