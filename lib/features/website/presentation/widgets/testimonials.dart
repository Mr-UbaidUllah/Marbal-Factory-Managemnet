import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final testimonials = [
      {
        'name': 'Sarah Johnson',
        'role': 'Interior Designer',
        'comment': 'The quality of marble from Alam Factory is unparalleled. Their attention to detail and professional installation made my penthouse project a masterpiece.',
        'rating': 5,
        'image': 'https://i.pravatar.cc/150?u=1',
      },
      {
        'name': 'Ahmed Al-Maktoum',
        'role': 'Property Developer',
        'comment': 'Reliable, premium, and efficient. We have partnered with them for multiple luxury villas, and they never fail to deliver excellence on time.',
        'rating': 5,
        'image': 'https://i.pravatar.cc/150?u=2',
      },
      {
        'name': 'Elena Rodriguez',
        'role': 'Home Owner',
        'comment': 'From the showroom visit to the final countertop installation, the experience was seamless. Our kitchen looks like a dream thanks to their Granite collection.',
        'rating': 5,
        'image': 'https://i.pravatar.cc/150?u=3',
      },
    ];

    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 100,
        horizontal: isMobile ? 20 : 80,
      ),
      color: Colors.white,
      child: Column(
        children: [
          FadeInUp(
            child: Column(
              children: [
                Text(
                  "TESTIMONIALS",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.gold,
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "What Our Clients Say",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2.copyWith(
                    fontSize: isMobile ? 32 : 42,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
          if (isMobile)
            Column(
              children: testimonials.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: FadeInUp(
                  delay: Duration(milliseconds: 200 * testimonials.indexOf(t)),
                  child: _TestimonialCard(testimonial: t),
                ),
              )).toList(),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: testimonials.map((t) => Expanded(
                child: FadeInUp(
                  delay: Duration(milliseconds: 200 * testimonials.indexOf(t)),
                  child: _TestimonialCard(testimonial: t),
                ),
              )).toList(),
            ),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final Map<String, dynamic> testimonial;
  const _TestimonialCard({required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      elevation: 0,
      color: AppColors.lightGray.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => const Icon(Icons.star, color: AppColors.gold, size: 20),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "\"${testimonial['comment']}\"",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                fontStyle: FontStyle.italic,
                height: 1.6,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              backgroundImage: NetworkImage(testimonial['image'] as String),
              onBackgroundImageError: (exception, stackTrace) => const Icon(Icons.person),
            ),
            const SizedBox(height: 15),
            Text(
              testimonial['name'] as String,
              style: AppTextStyles.h3.copyWith(fontSize: 18),
            ),
            Text(
              testimonial['role'] as String,
              style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
