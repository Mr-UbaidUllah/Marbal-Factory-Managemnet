import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Marble', 'image': 'https://images.unsplash.com/photo-1605276374104-dee2a0ed3cd6?q=80&w=1000&auto=format&fit=crop'},
      {'name': 'Granite', 'image': 'https://images.unsplash.com/photo-1517483000871-1dbf64a6e1c6?q=80&w=1000&auto=format&fit=crop'},
      {'name': 'Onyx', 'image': 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?q=80&w=1000&auto=format&fit=crop'},
      {'name': 'Quartz', 'image': 'https://images.unsplash.com/photo-1615529328331-f8917597711f?q=80&w=1000&auto=format&fit=crop'},
      {'name': 'Travertine', 'image': 'https://images.unsplash.com/photo-1599619351208-3e6c839d7824?q=80&w=1000&auto=format&fit=crop'},
      {'name': 'Slabs', 'image': 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?q=80&w=1000&auto=format&fit=crop'},
    ];

    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width >= 768 && size.width < 1024;

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
                  "OUR CATEGORIES",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.gold,
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Exquisite Stone Collections",
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: 1.2,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return FadeInUp(
                delay: Duration(milliseconds: 100 * index),
                child: _CategoryCard(
                  name: categories[index]['name']!,
                  image: categories[index]['image']!,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final String name;
  final String image;
  const _CategoryCard({required this.name, required this.image});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (isHovered)
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedScale(
                scale: isHovered ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 600),
                child: Image.network(
                  widget.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.image_not_supported, color: AppColors.primary),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(isHovered ? 0.8 : 0.4),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 30,
                right: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isHovered ? 100 : 0,
                      height: 2,
                      color: AppColors.gold,
                    ),
                    if (isHovered)
                      FadeInUp(
                        duration: const Duration(milliseconds: 300),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "View Collection →",
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
