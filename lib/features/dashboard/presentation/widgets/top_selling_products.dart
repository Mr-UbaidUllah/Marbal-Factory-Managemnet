import 'package:flutter/material.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/shared/widgets/custom_card.dart';

class TopSellingProducts extends StatelessWidget {
  const TopSellingProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Top Selling Products', style: AppTextStyles.h3),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: AppTextStyles.label.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 320,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return _buildProductCard(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(int index) {
    final products = [
      {
        'name': 'Carrara White Marble',
        'cat': 'Marble',
        'price': '\$120/m2',
        'sales': '420 sold',
        'rating': '4.9',
      },
      {
        'name': 'Absolute Black Granite',
        'cat': 'Granite',
        'price': '\$85/m2',
        'sales': '380 sold',
        'rating': '4.8',
      },
      {
        'name': 'Calacatta Gold',
        'cat': 'Marble',
        'price': '\$250/m2',
        'sales': '150 sold',
        'rating': '5.0',
      },
      {
        'name': 'Emerald Quartzite',
        'cat': 'Slabs',
        'price': '\$180/m2',
        'sales': '95 sold',
        'rating': '4.7',
      },
      {
        'name': 'Travertine Beige',
        'cat': 'Tiles',
        'price': '\$45/m2',
        'sales': '600 sold',
        'rating': '4.6',
      },
    ];

    final product = products[index];

    return CustomCard(
      width: 220,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1615529328331-f8917597711f?q=80&w=200&auto=format&fit=crop',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.gold,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product['rating']!,
                          style: AppTextStyles.label.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['cat']!,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.primary,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product['name']!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        product['price']!,
                        style: AppTextStyles.price.copyWith(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        product['sales']!,
                        style: AppTextStyles.bodySmall,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
