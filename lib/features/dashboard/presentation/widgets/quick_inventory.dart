import 'package:flutter/material.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/shared/widgets/custom_card.dart';


class QuickInventory extends StatelessWidget {
  const QuickInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16), onTap: () {  }, title: '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Inventory', style: AppTextStyles.h3),
          const SizedBox(height: 24),
          _buildInventoryItem('Available Slabs', 1240, AppColors.success),
          const SizedBox(height: 16),
          _buildInventoryItem('Reserved', 450, AppColors.info),
          const SizedBox(height: 16),
          _buildInventoryItem('Sold', 890, AppColors.primary),
          const SizedBox(height: 16),
          _buildInventoryItem('Damaged', 12, AppColors.error),
        ],
      ),
    );
  }

  Widget _buildInventoryItem(String label, int value, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodySmall),
            Text(
              value.toString(),
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 2000, // Just for demonstration
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
