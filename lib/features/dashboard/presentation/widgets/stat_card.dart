import 'package:flutter/material.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/shared/widgets/custom_card.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String growth;
  final bool isPositive;
  final IconData icon;
  final Color iconColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.growth,
    required this.isPositive,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Allow card to shrink
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              Flexible(child: _buildTrendIndicator()),
            ],
          ),
          const SizedBox(height: 20),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: AppTextStyles.h2.copyWith(fontSize: 28)),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.show_chart,
                size: 32,
                color: AppColors.lightGray.withOpacity(0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isPositive ? AppColors.success : AppColors.error).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            size: 14,
            color: isPositive ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: 4),
          Text(
            growth,
            style: AppTextStyles.label.copyWith(
              color: isPositive ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class StatisticsGrid extends StatelessWidget {
  const StatisticsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 4;
        double aspectRatio = 1.1;

        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
          aspectRatio = 2.5;
        } else if (constraints.maxWidth < 1200) {
          crossAxisCount = 2;
          aspectRatio = 1.4;
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: aspectRatio,
          children: const [
            StatCard(
              title: 'Total Products',
              value: '1,284',
              growth: '+12.5%',
              isPositive: true,
              icon: Icons.inventory_2_outlined,
              iconColor: AppColors.primary,
            ),
            StatCard(
              title: 'Monthly Revenue',
              value: '\$84,200',
              growth: '+18.2%',
              isPositive: true,
              icon: Icons.payments_outlined,
              iconColor: AppColors.gold,
            ),
            StatCard(
              title: 'Quote Requests',
              value: '48',
              growth: '-4.1%',
              isPositive: false,
              icon: Icons.request_quote_outlined,
              iconColor: AppColors.info,
            ),
            StatCard(
              title: 'Low Stock Items',
              value: '12',
              growth: '+2',
              isPositive: false,
              icon: Icons.warning_amber_rounded,
              iconColor: AppColors.error,
            ),
          ],
        );
      },
    );
  }
}
