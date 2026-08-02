import 'package:flutter/material.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';

class LoginHero extends StatelessWidget {
  const LoginHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image with Marble Texture
        Positioned.fill(
          child: Image.network(
            'https://images.unsplash.com/photo-1503174971373-b1f69850bbd6?q=80&w=2070&auto=format&fit=crop',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: AppColors.primaryDark,
            ),
          ),
        ),
        
        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryDark.withOpacity(0.9),
                  AppColors.primary.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),
        
        // Content
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo placeholder
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.architecture,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Alam Marble & Granite\nFactory',
                    style: AppTextStyles.h1.copyWith(
                      color: Colors.white,
                      fontSize: 48,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 2,
                    width: 60,
                    color: AppColors.gold,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Crafting Luxury in Every Stone',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Manage your inventory, products, customers, and business operations from one powerful dashboard.',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Floating Geometric Shapes (Subtle)
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
