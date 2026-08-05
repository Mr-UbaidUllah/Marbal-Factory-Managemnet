import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/products/domain/entities/product.dart';
import 'package:factory_management/features/products/presentation/bloc/product_bloc.dart';
import 'package:factory_management/features/products/presentation/bloc/product_event.dart';
import 'package:factory_management/features/products/presentation/bloc/product_state.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductBloc>()..add(GetProductEvent(widget.productId)),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(HugeIcons.strokeRoundedArrowLeft01, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: Text('Product Details', style: AppTextStyles.h3),
          actions: [
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state.selectedProduct == null) return const SizedBox.shrink();
                final product = state.selectedProduct!;
                return Row(
                  children: [
                    IconButton(
                      tooltip: 'Edit Product',
                      icon: const Icon(HugeIcons.strokeRoundedEdit02, color: AppColors.primary),
                      onPressed: () => context.push('/dashboard/products/edit/${product.id}'),
                    ),
                    IconButton(
                      tooltip: 'Feature Product',
                      icon: Icon(
                        product.featured ? HugeIcons.strokeRoundedStar : HugeIcons.strokeRoundedStar, 
                        color: product.featured ? AppColors.gold : AppColors.textSecondary,
                      ),
                      onPressed: () {
                        context.read<ProductBloc>().add(UpdateProductEvent(product.copyWith(featured: !product.featured)));
                      },
                    ),
                    IconButton(
                      tooltip: 'Delete Product',
                      icon: const Icon(HugeIcons.strokeRoundedDelete02, color: AppColors.error),
                      onPressed: () => _showDeleteDialog(context, product),
                    ),
                    const SizedBox(width: 8),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state.status == ProductStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.selectedProduct == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(HugeIcons.strokeRoundedPackageBox, size: 64, color: AppColors.textSecondary),
                    const SizedBox(height: 16),
                    Text('Product not found', style: AppTextStyles.h3),
                    const SizedBox(height: 24),
                    ElevatedButton(onPressed: () => context.pop(), child: const Text('Go Back')),
                  ],
                ),
              );
            }

            final product = state.selectedProduct!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainInfo(context, product),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildGeneralDetails(product),
                            const SizedBox(height: 24),
                            _buildAdvancedSpecs(product),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          children: [
                            _buildInventoryCard(product),
                            const SizedBox(height: 24),
                            _buildMetadataCard(product),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainInfo(BuildContext context, Product product) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageGallery(product),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildStatusBadge(product.status),
                    const SizedBox(width: 8),
                    if (product.featured)
                      _buildFeaturedBadge(),
                  ],
                ),
                const SizedBox(height: 16),
                Text(product.name, style: AppTextStyles.h1),
                const SizedBox(height: 4),
                Text('SKU: ${product.sku}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      NumberFormat.currency(symbol: 'Rs').format(product.price),
                      style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    if (product.discountPrice < product.price)
                      Text(
                        NumberFormat.currency(symbol: 'Rs').format(product.discountPrice),
                        style: AppTextStyles.h3.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Description', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(product.description, style: AppTextStyles.bodyMedium.copyWith(height: 1.6)),
                if (product.shortDescription.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(product.shortDescription, style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(Product product) {
    if (product.images.isEmpty) {
      return Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(HugeIcons.strokeRoundedImageNotAvailable01, size: 64, color: AppColors.textSecondary),
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => _showFullScreenImage(context, product.images[_selectedImageIndex]),
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(product.images[_selectedImageIndex]),
                fit: BoxFit.cover,
              ),
            ),
            child: const Stack(
              children: [
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Icon(HugeIcons.strokeRoundedZoomIn01, color: Colors.white, size: 24),
                ),
              ],
            ),
          ),
        ),
        if (product.images.length > 1) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            width: 400,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: product.images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => setState(() => _selectedImageIndex = index),
                child: Container(
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _selectedImageIndex == index ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(product.images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGeneralDetails(Product product) {
    return _buildCard(
      title: 'Specifications',
      children: [
        _buildSpecGrid([
          {'label': 'Category', 'value': product.categoryName},
          {'label': 'Material', 'value': product.materialType},
          {'label': 'Finish', 'value': product.finish},
          {'label': 'Color', 'value': product.color},
          {'label': 'Thickness', 'value': product.thickness},
          {'label': 'Dimensions', 'value': product.dimensions},
          {'label': 'Origin', 'value': product.originCountry},
          {'label': 'Weight', 'value': '${product.weight} kg/${product.unit}'},
        ]),
      ],
    );
  }

  Widget _buildAdvancedSpecs(Product product) {
    if (product.waterAbsorption == null && product.hardness == null && product.application == null && product.edgeType == null) {
      return const SizedBox.shrink();
    }

    return _buildCard(
      title: 'Technical Data',
      children: [
        _buildSpecGrid([
          if (product.waterAbsorption != null) {'label': 'Water Absorption', 'value': product.waterAbsorption!},
          if (product.hardness != null) {'label': 'Hardness', 'value': product.hardness!},
          if (product.application != null) {'label': 'Application', 'value': product.application!},
          if (product.edgeType != null) {'label': 'Edge Type', 'value': product.edgeType!},
        ]),
      ],
    );
  }

  Widget _buildSpecGrid(List<Map<String, String>> specs) {
    return Wrap(
      spacing: 40,
      runSpacing: 24,
      children: specs.map((spec) => SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(spec['label']!, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 4),
            Text(spec['value']!, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildInventoryCard(Product product) {
    final isLowStock = product.stockQuantity <= product.minimumStock;

    return _buildCard(
      title: 'Inventory',
      children: [
        _buildInventoryItem('Current Stock', '${product.stockQuantity} ${product.unit}', 
          valueColor: isLowStock ? AppColors.error : AppColors.primary),
        const Divider(height: 32),
        _buildInventoryItem('Minimum Stock', '${product.minimumStock} ${product.unit}'),
        const Divider(height: 32),
        _buildInventoryItem('Unit of Measure', product.unit),
        if (isLowStock) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(HugeIcons.strokeRoundedAlertCircle, color: AppColors.error, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    product.stockQuantity <= 0 ? 'Out of Stock!' : 'Stock is below minimum level!', 
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.error, fontWeight: FontWeight.bold)
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMetadataCard(Product product) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');
    return _buildCard(
      title: 'Product History',
      children: [
        _buildMetadataItem('Created By', product.createdBy ?? 'System'),
        _buildMetadataItem('Created At', dateFormat.format(product.createdAt)),
        const Divider(height: 24),
        _buildMetadataItem('Last Updated By', product.lastUpdatedBy ?? product.createdBy ?? 'System'),
        _buildMetadataItem('Last Updated', dateFormat.format(product.updatedAt)),
      ],
    );
  }

  Widget _buildInventoryItem(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        Text(value, style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: valueColor ?? AppColors.textPrimary,
        )),
      ],
    );
  }

  Widget _buildMetadataItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          Text(value, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h3),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ProductStatus status) {
    Color color;
    String label;

    switch (status) {
      case ProductStatus.inStock: color = Colors.green; label = 'In Stock'; break;
      case ProductStatus.lowStock: color = Colors.orange; label = 'Low Stock'; break;
      case ProductStatus.outOfStock: color = Colors.red; label = 'Out of Stock'; break;
      case ProductStatus.inactive: color = Colors.grey; label = 'Inactive'; break;
      case ProductStatus.archived: color = Colors.blueGrey; label = 'Archived'; break;
      case ProductStatus.featured: color = AppColors.gold; label = 'Featured'; break;
      case ProductStatus.draft: color = Colors.blue; label = 'Draft'; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildFeaturedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(HugeIcons.strokeRoundedStar, color: AppColors.gold, size: 12),
          SizedBox(width: 4),
          Text(
            'FEATURED',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.gold,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Product product) {
    final bloc = context.read<ProductBloc>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"? This action will archive the product.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              bloc.add(DeleteProductEvent(product.id));
              Navigator.pop(context);
              context.pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            InteractiveViewer(
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(HugeIcons.strokeRoundedCancel01, color: Colors.white, size: 32),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
