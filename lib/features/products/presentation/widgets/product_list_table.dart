import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/products/domain/entities/product.dart';
import 'package:factory_management/features/products/presentation/bloc/product_bloc.dart';
import 'package:factory_management/features/products/presentation/bloc/product_event.dart';
import 'package:factory_management/features/products/presentation/bloc/product_state.dart' hide ProductStatus;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProductListTable extends StatelessWidget {
  final List<Product> products;

  const ProductListTable({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.totalProducts == 0 && state.status == ProductStatus.success) {
          return const SizedBox.shrink();
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(AppColors.surface),
                        dataRowMaxHeight: 80,
                        columnSpacing: 24,
                        showCheckboxColumn: false,
                        columns: [
                          DataColumn(
                            label: Checkbox(
                              value: products.isNotEmpty && state.selectedProductIds.length == products.length,
                              onChanged: (value) {
                                if (value == true) {
                                  context.read<ProductBloc>().add(const SelectAllProductsEvent());
                                } else {
                                  context.read<ProductBloc>().add(const ClearSelectionEvent());
                                }
                              },
                            ),
                          ),
                          DataColumn(label: Text('Product', style: AppTextStyles.label)),
                          DataColumn(label: Text('SKU', style: AppTextStyles.label)),
                          DataColumn(label: Text('Category', style: AppTextStyles.label)),
                          DataColumn(label: Text('Price', style: AppTextStyles.label)),
                          DataColumn(label: Text('Stock', style: AppTextStyles.label)),
                          DataColumn(label: Text('Status', style: AppTextStyles.label)),
                          DataColumn(label: Text('Actions', style: AppTextStyles.label)),
                        ],
                        rows: products.map((product) => _buildRow(context, product, state.selectedProductIds.contains(product.id))).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              _buildPagination(context, state),
            ],
          ),
        );
      },
    );
  }

  DataRow _buildRow(BuildContext context, Product product, bool isSelected) {
    final currencyFormat = NumberFormat.currency(symbol: 'Rs');
    
    return DataRow(
      selected: isSelected,
      cells: [
        DataCell(
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              context.read<ProductBloc>().add(ToggleProductSelectionEvent(product.id));
            },
          ),
        ),
        DataCell(
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  image: product.images.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(product.images.first),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: product.images.isEmpty
                    ? const Center(child: FaIcon(FontAwesomeIcons.image, size: 20, color: AppColors.textSecondary))
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  Text(product.materialType, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        ),
        DataCell(Text(product.sku, style: AppTextStyles.bodyMedium)),
        DataCell(Text(product.categoryName, style: AppTextStyles.bodyMedium)),
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(currencyFormat.format(product.price), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              if (product.discountPrice < product.price)
                Text(
                  currencyFormat.format(product.discountPrice),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),
        ),
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${product.stockQuantity} ${product.unit}', 
                style: AppTextStyles.bodyMedium.copyWith(
                  color: product.stockQuantity <= product.minimumStock ? AppColors.error : AppColors.textPrimary,
                  fontWeight: product.stockQuantity <= product.minimumStock ? FontWeight.bold : FontWeight.normal,
                )
              ),
              if (product.stockQuantity <= product.minimumStock && product.stockQuantity > 0)
                Text('Low Stock', style: AppTextStyles.bodySmall.copyWith(color: AppColors.error, fontSize: 10)),
              if (product.stockQuantity <= 0)
                Text('Out of Stock', style: AppTextStyles.bodySmall.copyWith(color: AppColors.error, fontSize: 10)),
            ],
          ),
        ),
        DataCell(_buildStatusBadge(product.status)),
        DataCell(
          Row(
            children: [
              IconButton(
                tooltip: 'View Details',
                icon: const FaIcon(FontAwesomeIcons.eye, size: 18, color: AppColors.textSecondary),
                onPressed: () => context.push('/dashboard/products/${product.id}'),
              ),
              IconButton(
                tooltip: 'Edit Product',
                icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 18, color: AppColors.textSecondary),
                onPressed: () => context.push('/dashboard/products/edit/${product.id}'),
              ),
              IconButton(
                tooltip: 'Delete Product',
                icon: const FaIcon(FontAwesomeIcons.trashCan, size: 18, color: AppColors.error),
                onPressed: () => _showDeleteDialog(context, product),
              ),
            ],
          ),
        ),
      ],
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
      case ProductStatus.success:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ProductStatus.loading:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildPagination(BuildContext context, ProductState state) {
    if (state.totalProducts == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${(state.currentPage - 1) * state.pageSize + 1} to ${((state.currentPage * state.pageSize) > state.totalProducts) ? state.totalProducts : (state.currentPage * state.pageSize)} of ${state.totalProducts} products',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          Row(
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.chevronLeft, size: 14),
                onPressed: state.currentPage > 1
                    ? () => context.read<ProductBloc>().add(ChangePageEvent(state.currentPage - 1))
                    : null,
              ),
              const SizedBox(width: 8),
              if (state.totalPages <= 5)
                ...List.generate(state.totalPages, (index) {
                  final page = index + 1;
                  return _buildPageNumber(context, page, state.currentPage == page);
                })
              else ...[
                _buildPageNumber(context, 1, state.currentPage == 1),
                if (state.currentPage > 3) const Text('...'),
                if (state.currentPage > 2 && state.currentPage < state.totalPages - 1)
                  _buildPageNumber(context, state.currentPage, true),
                if (state.currentPage < state.totalPages - 2) const Text('...'),
                _buildPageNumber(context, state.totalPages, state.currentPage == state.totalPages),
              ],
              const SizedBox(width: 8),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.chevronRight, size: 14),
                onPressed: state.currentPage < state.totalPages
                    ? () => context.read<ProductBloc>().add(ChangePageEvent(state.currentPage + 1))
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageNumber(BuildContext context, int page, bool isCurrent) {
    return GestureDetector(
      onTap: () => context.read<ProductBloc>().add(ChangePageEvent(page)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isCurrent ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isCurrent ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          '$page',
          style: AppTextStyles.bodySmall.copyWith(
            color: isCurrent ? Colors.white : AppColors.textPrimary,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Product product) {
    final productBloc = context.read<ProductBloc>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"? This will move it to the archives.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              productBloc.add(DeleteProductEvent(product.id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
