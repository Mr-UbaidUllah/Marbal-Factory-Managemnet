import 'package:flutter/material.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/shared/widgets/custom_card.dart';


class LowStockAlerts extends StatelessWidget {
  const LowStockAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Low Stock Alerts', style: AppTextStyles.h3),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _buildAlertCard(index);
          },
        ),
      ],
    );
  }

  Widget _buildAlertCard(int index) {
    final alerts = [
      {'name': 'Statuario Marble', 'stock': '2 Slabs', 'min': '10 Slabs'},
      {'name': 'Golden Spider', 'stock': '5 Slabs', 'min': '15 Slabs'},
      {'name': 'Volakas White', 'stock': '8 Slabs', 'min': '20 Slabs'},
    ];
    final alert = alerts[index];

    return CustomCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.warning,
              color: AppColors.error,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert['name']!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Current stock: ${alert['stock']}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Restock soon',
                style: AppTextStyles.label.copyWith(color: AppColors.error),
              ),
              Text('Min: ${alert['min']}', style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
