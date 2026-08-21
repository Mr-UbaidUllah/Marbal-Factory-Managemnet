import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_bloc.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_event.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_state.dart';
import 'package:factory_management/core/router/route_paths.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CategoryBloc>()..add(const LoadCategories(active: true)),
      child: const CategorySectionContent(),
    );
  }
}

class CategorySectionContent extends StatelessWidget {
  const CategorySectionContent({super.key});

  @override
  Widget build(BuildContext context) {
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
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state.status == CategoryStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              final categories = state.categories.where((c) => c.active).take(6).toList();

              if (categories.isEmpty) {
                return const SizedBox.shrink();
              }

              return GridView.builder(
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
                      id: categories[index].id,
                      name: categories[index].name,
                      image: categories[index].image,
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 60),
          FadeInUp(
            child: ElevatedButton(
              onPressed: () => context.go(RoutePaths.categories),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text("View All Categories"),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final String id;
  final String name;
  final String? image;
  const _CategoryCard({required this.id, required this.name, this.image});

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
      child: GestureDetector(
        onTap: () => context.go('${RoutePaths.products}?category=${widget.id}'),
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
                  child: widget.image != null && widget.image!.isNotEmpty
                      ? Image.network(
                          widget.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
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
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      child: const Icon(Icons.category_outlined, size: 48, color: AppColors.primary),
    );
  }
}
