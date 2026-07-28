import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';

class WhyChooseUs extends StatelessWidget {
  const WhyChooseUs({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'title': 'Premium Quality Stone',
        'desc': 'We source only the finest marble and granite from the most prestigious quarries worldwide.',
        'icon': Icons.diamond_outlined,
      },
      {
        'title': 'Imported & Local Collection',
        'desc': 'A vast selection of exotic stones from Italy, Greece, Brazil, and premium local materials.',
        'icon': Icons.public,
      },
      {
        'title': 'Professional Installation',
        'desc': 'Our expert craftsmen ensure flawless installation with precision and care for every project.',
        'icon': Icons.handyman_outlined,
      },
      {
        'title': 'Competitive Pricing',
        'desc': 'Get the best value for luxury materials without compromising on quality or service.',
        'icon': Icons.payments_outlined,
      },
      {
        'title': 'Nationwide Delivery',
        'desc': 'Efficient and safe logistics to deliver your stone anywhere in the country.',
        'icon': Icons.local_shipping_outlined,
      },
      {
        'title': 'Experienced Team',
        'desc': 'Over 20 years of expertise in stone manufacturing and design consultancy.',
        'icon': Icons.groups_outlined,
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 80),
      color: AppColors.primaryDark,
      child: Column(
        children: [
          FadeInUp(
            child: Column(
              children: [
                Text(
                  "WHY CHOOSE ALAM MARBLE",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.gold,
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Crafting Excellence in Every Detail",
                  style: AppTextStyles.h2.copyWith(
                    fontSize: 42, 
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 40,
              mainAxisSpacing: 40,
              childAspectRatio: 1.5,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              return FadeInUp(
                delay: Duration(milliseconds: 100 * index),
                child: _FeatureCard(feature: features[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final Map<String, dynamic> feature;
  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(feature['icon'] as IconData, color: AppColors.gold, size: 40),
          const SizedBox(height: 19),
          Text(
            feature['title'] as String,
            style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 15),
          Text(
            feature['desc'] as String,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.7),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
