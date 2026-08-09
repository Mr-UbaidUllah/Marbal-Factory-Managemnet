import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/inventory/domain/entities/inventory.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_state.dart';

class InventoryStatsCards extends StatelessWidget {
  const InventoryStatsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        final totalProducts = state.inventory.length;
        final totalStock = state.inventory.fold(0, (sum, item) => sum + item.quantity);
        final lowStock = state.inventory.where((item) => item.status == InventoryStatus.lowStock).length;
        final outOfStock = state.inventory.where((item) => item.status == InventoryStatus.outOfStock).length;

        return LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final int crossAxisCount = width < 600 ? 1 : (width < 1200 ? 2 : 4);
            
            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5,
              children: [
                _buildStatCard(
                  'Total Products',
                  totalProducts.toString(),
                  FontAwesomeIcons.boxesStacked as IconData,
                  AppColors.primary,
                ),
                _buildStatCard(
                  'Total Stock Units',
                  totalStock.toString(),
                  FontAwesomeIcons.cubes as IconData,
                  Colors.blue,
                ),
                _buildStatCard(
                  'Low Stock',
                  lowStock.toString(),
                  FontAwesomeIcons.triangleExclamation as IconData,
                  AppColors.warning,
                ),
                _buildStatCard(
                  'Out of Stock',
                  outOfStock.toString(),
                  FontAwesomeIcons.circleExclamation as IconData,
                  AppColors.error,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(icon as FaIconData?, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
