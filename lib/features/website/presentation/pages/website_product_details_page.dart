import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/products/domain/entities/product.dart';
import 'package:factory_management/features/products/presentation/bloc/product_bloc.dart';
import 'package:factory_management/features/products/presentation/bloc/product_event.dart';
import 'package:factory_management/features/products/presentation/bloc/product_state.dart' hide ProductStatus;
import 'package:factory_management/features/website/presentation/widgets/website_navbar.dart';
import 'package:factory_management/features/website/presentation/widgets/website_footer.dart';
import 'package:factory_management/features/website/presentation/widgets/website_product_card.dart';

class WebsiteProductDetailsPage extends StatefulWidget {
  final String productId;
  const WebsiteProductDetailsPage({super.key, required this.productId});

  @override
  State<WebsiteProductDetailsPage> createState() => _WebsiteProductDetailsPageState();
}

class _WebsiteProductDetailsPageState extends State<WebsiteProductDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 50 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 50 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ProductBloc>()..add(GetProductEvent(widget.productId)),
        ),
        BlocProvider(
          create: (context) => sl<ProductBloc>()..add(const LoadProductsEvent()), // For related products
        ),
      ],
      child: Scaffold(
        appBar: WebsiteNavbar(isScrolled: _isScrolled),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              const SizedBox(height: 100), // Navbar space
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state.status == ProductStatus.loading && state.selectedProduct == null) {
                    return const SizedBox(
                      height: 600,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state.selectedProduct == null) {
                    return SizedBox(
                      height: 600,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                            const SizedBox(height: 16),
                            Text("Product not found", style: AppTextStyles.h2),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () => context.go('/products'),
                              child: const Text("Back to Products"),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final product = state.selectedProduct!;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBreadcrumbs(context, product),
                            const SizedBox(height: 40),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                if (constraints.maxWidth < 900) {
                                  return Column(
                                    children: [
                                      _buildGallery(product),
                                      const SizedBox(height: 40),
                                      _buildInfo(context, product),
                                    ],
                                  );
                                }
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(flex: 1, child: _buildGallery(product)),
                                    const SizedBox(width: 60),
                                    Expanded(flex: 1, child: _buildInfo(context, product)),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 80),
                            _buildDetailedSpecs(product),
                            const SizedBox(height: 80),
                            _buildRelatedProducts(context, product),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              WebsiteFooter(
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumbs(BuildContext context, Product product) {
    return Row(
      children: [
        TextButton(
          onPressed: () => context.go('/'),
          child: Text("Home", style: AppTextStyles.bodySmall),
        ),
        const Icon(Icons.chevron_right, size: 16, color: AppColors.textTertiary),
        TextButton(
          onPressed: () => context.go('/products'),
          child: Text("Products", style: AppTextStyles.bodySmall),
        ),
        const Icon(Icons.chevron_right, size: 16, color: AppColors.textTertiary),
        Text(product.name, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildGallery(Product product) {
    if (product.images.isEmpty) {
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          color: AppColors.lightGray,
          child: const Center(child: Icon(Icons.image_not_supported, size: 100, color: AppColors.textTertiary)),
        ),
      );
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              product.images[_selectedImageIndex],
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (product.images.length > 1) ...[
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: product.images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 15),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => setState(() => _selectedImageIndex = index),
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _selectedImageIndex == index ? AppColors.gold : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(product.images[index], fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfo(BuildContext context, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            product.categoryName.toUpperCase(),
            style: AppTextStyles.label.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        Text(product.name, style: AppTextStyles.h1.copyWith(fontSize: 42)),
        const SizedBox(height: 10),
        Text("SKU: ${product.sku}", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary)),
        const SizedBox(height: 30),
        const Divider(),
        const SizedBox(height: 30),
        _buildSpecRow("Material Type", product.materialType),
        _buildSpecRow("Finish", product.finish),
        _buildSpecRow("Color", product.color),
        _buildSpecRow("Origin", product.originCountry),
        _buildSpecRow("Dimensions", product.dimensions),
        _buildSpecRow("Thickness", product.thickness),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () => context.push('/quote-request?productId=${product.id}'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("REQUEST A QUOTE", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Text("$label:", style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Text(value, style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildDetailedSpecs(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Product Description", style: AppTextStyles.h2),
        const SizedBox(height: 20),
        Text(
          product.description,
          style: AppTextStyles.bodyLarge.copyWith(height: 1.8),
        ),
        const SizedBox(height: 60),
        if (product.waterAbsorption != null || product.hardness != null || product.application != null) ...[
          Text("Technical Specifications", style: AppTextStyles.h2),
          const SizedBox(height: 30),
          Table(
            border: TableBorder.all(color: AppColors.border),
            children: [
              if (product.waterAbsorption != null) _buildTableRow("Water Absorption", product.waterAbsorption!),
              if (product.hardness != null) _buildTableRow("Hardness (Mohs)", product.hardness!),
              if (product.application != null) _buildTableRow("Recommended Application", product.application!),
              if (product.edgeType != null) _buildTableRow("Edge Type", product.edgeType!),
            ],
          ),
        ],
      ],
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(value),
        ),
      ],
    );
  }

  Widget _buildRelatedProducts(BuildContext context, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Related Products", style: AppTextStyles.h2),
            TextButton(
              onPressed: () => context.go('/products'),
              child: const Text("View All"),
            ),
          ],
        ),
        const SizedBox(height: 30),
        BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            final related = state.products.where((p) => p.id != product.id && p.categoryId == product.categoryId).take(4).toList();
            
            if (related.isEmpty) return const SizedBox.shrink();

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 0.75,
              ),
              itemCount: related.length,
              itemBuilder: (context, index) {
                return WebsiteProductCard(product: related[index]);
              },
            );
          },
        ),
      ],
    );
  }
}
