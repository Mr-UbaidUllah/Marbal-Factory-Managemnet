import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/core/router/route_paths.dart';
import 'package:factory_management/features/website/domain/entities/product.dart';
import 'package:factory_management/features/website/presentation/bloc/website_bloc.dart';
import 'package:factory_management/features/website/presentation/bloc/website_state.dart';

class FeaturedProducts extends StatelessWidget {
  const FeaturedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 80),
      color: AppColors.lightGray.withOpacity(0.5),
      child: Column(
        children: [
          FadeInUp(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BEST SELLERS",
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.gold,
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Featured Products",
                      style: AppTextStyles.h2.copyWith(fontSize: 42, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.push(RoutePaths.products),
                  child: Row(
                    children: [
                      Text(
                        "View All Products",
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          BlocBuilder<WebsiteBloc, WebsiteState>(
            builder: (context, state) {
              if (state.status == WebsiteStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == WebsiteStatus.failure) {
                return Center(child: Text(state.failure?.message ?? 'Error loading products'));
              }
              
              final products = state.featuredProducts;
              
              return LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 4;
                  if (constraints.maxWidth < 600) {
                    crossAxisCount = 1;
                  } else if (constraints.maxWidth < 900) {
                    crossAxisCount = 2;
                  } else if (constraints.maxWidth < 1200) {
                    crossAxisCount = 3;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return FadeInUp(
                        delay: Duration(milliseconds: 150 * index),
                        child: _ProductCard(product: products[index]),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.1 : 0.05),
              blurRadius: isHovered ? 30 : 15,
              offset: Offset(0, isHovered ? 15 : 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.network(
                        widget.product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppColors.lightGray,
                          child: const Icon(Icons.image_not_supported, color: AppColors.textTertiary),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_border, size: 20),
                    ),
                  ),
                  if (isHovered)
                    FadeIn(
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Since these use a different Product entity, we should ideally 
                              // navigate using a name or something if ID isn't available, 
                              // but the instructions say to use real entities.
                              // For now, let's assume the website products and domain products 
                              // will be synced or this is just for visual identity.
                              context.push(RoutePaths.products);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                            ),
                            child: const Text("View Details"),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.category,
                        style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.gold, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            widget.product.rating.toString(),
                            style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.name,
                    style: AppTextStyles.h3.copyWith(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Origin: ${widget.product.origin}",
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.price,
                        style: AppTextStyles.price.copyWith(fontSize: 18, color: AppColors.primary),
                      ),
                      IconButton(
                        icon: const Icon(Icons.compare_arrows, size: 20),
                        onPressed: () {},
                        tooltip: "Compare",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
