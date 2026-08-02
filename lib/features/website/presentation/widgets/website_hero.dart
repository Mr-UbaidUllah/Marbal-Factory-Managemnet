import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';

class WebsiteHero extends StatelessWidget {
  const WebsiteHero({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Stack(
      children: [
        // Background Image
        Container(
          height: size.height,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=2070&auto=format&fit=crop'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        
        // Content
        Positioned.fill(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInLeft(
                    duration: const Duration(seconds: 1),
                    child: Text(
                      "CRAFTING LUXURY\nIN EVERY STONE",
                      style: AppTextStyles.h1.copyWith(
                        color: Colors.white,
                        fontSize: isMobile ? 48 : 80,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        letterSpacing: -2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInLeft(
                    delay: const Duration(milliseconds: 300),
                    duration: const Duration(seconds: 1),
                    child: SizedBox(
                      width: isMobile ? double.infinity : 600,
                      child: Text(
                        "Luxury Marble & Granite for Timeless Spaces. Discover premium natural stone for homes, offices, hotels, and commercial projects.",
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: isMobile ? 16 : 20,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    duration: const Duration(seconds: 1),
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                          ),
                          child: Text(
                            "Explore Collection",
                            style: AppTextStyles.button.copyWith(fontSize: 18),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white, width: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            "Request Free Quote",
                            style: AppTextStyles.button.copyWith(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Scroll Indicator
        if (!isMobile)
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FadeInDown(
                child: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 40),
              ),
            ),
          ),
      ],
    );
  }
}
