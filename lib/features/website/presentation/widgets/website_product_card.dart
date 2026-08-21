import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/products/domain/entities/product.dart';

class WebsiteProductCard extends StatefulWidget {
  final Product product;
  const WebsiteProductCard({super.key, required this.product});

  @override
  State<WebsiteProductCard> createState() => _WebsiteProductCardState();
}

class _WebsiteProductCardState extends State<WebsiteProductCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () => context.push('/products/${widget.product.id}'),
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
                        child: widget.product.images.isNotEmpty
                            ? Image.network(
                                widget.product.images.first,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
                      ),
                    ),
                    if (widget.product.featured)
                      Positioned(
                        top: 15,
                        left: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "FEATURED",
                            style: AppTextStyles.label.copyWith(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    if (isHovered)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () => context.push('/products/${widget.product.id}'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                            ),
                            child: const Text("View Details"),
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
                          widget.product.categoryName,
                          style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
                        ),
                        Text(
                          widget.product.materialType,
                          style: AppTextStyles.label.copyWith(color: AppColors.gold),
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
                      "Origin: ${widget.product.originCountry}",
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "SKU: ${widget.product.sku}",
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                        ),
                        TextButton(
                          onPressed: () => context.push('/quote-request?productId=${widget.product.id}'),
                          child: const Text("Request Quote"),
                        ),
                      ],
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

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.lightGray,
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined, size: 48, color: AppColors.textTertiary),
      ),
    );
  }
}
