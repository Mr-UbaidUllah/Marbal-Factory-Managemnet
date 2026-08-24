import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/shared/widgets/custom_card.dart';
import 'package:factory_management/core/router/route_paths.dart';

class RecentQuoteRequests extends StatelessWidget {
  const RecentQuoteRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () => context.go('${RoutePaths.dashboard}/${RoutePaths.quotations}'),
      title: '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Quote Requests', style: AppTextStyles.h3),
              TextButton(
                onPressed: () => context.go('${RoutePaths.dashboard}/${RoutePaths.quotations}'),
                child: Text(
                  'View All',
                  style: AppTextStyles.label.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildQuoteItem(
            context,
            '1',
            'Luxury Villa Project',
            'Marble Slabs',
            '200 m2',
            'SAR 45,000',
            'In Review',
          ),
          const Divider(height: 32),
          _buildQuoteItem(
            context,
            '2',
            'Hotel Lobby Reno',
            'Granite Tiles',
            '500 m2',
            'SAR 82,000',
            'Pending',
          ),
          const Divider(height: 32),
          _buildQuoteItem(
            context,
            '3',
            'Private Residence',
            'Quartz Countertop',
            '15 m2',
            'SAR 12,500',
            'Sent',
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteItem(
    BuildContext context,
    String id,
    String customer,
    String product,
    String qty,
    String budget,
    String status,
  ) {
    return InkWell(
      onTap: () => context.go('${RoutePaths.dashboard}/${RoutePaths.quotations}/$id'),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: const Icon(Icons.person,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text('$product • $qty', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(budget, style: AppTextStyles.price.copyWith(fontSize: 14)),
              Text(
                status,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
