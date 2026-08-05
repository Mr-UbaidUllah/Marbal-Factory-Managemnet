import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/products/presentation/bloc/product_bloc.dart';
import 'package:factory_management/features/products/presentation/bloc/product_event.dart';
import 'package:factory_management/features/products/presentation/bloc/product_state.dart';
import 'package:factory_management/features/products/presentation/widgets/product_list_table.dart';
import 'package:factory_management/features/products/presentation/widgets/product_filter_sidebar.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return BlocProvider(
      create: (context) => sl<ProductBloc>()..add(const LoadProductsEvent()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, isMobile),
                    const SizedBox(height: 24),
                    _buildActionBar(context, isMobile),
                    _buildActiveFilters(context),
                    const SizedBox(height: 16),
                    _buildBulkActionsBar(context),
                    const SizedBox(height: 8),
                    Expanded(
                      child: BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, state) {
                          if (state.status == ProductStatus.loading && state.products.isEmpty) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state.status == ProductStatus.failure) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const FaIcon(FontAwesomeIcons.circleExclamation, size: 48, color: AppColors.error),
                                  const SizedBox(height: 16),
                                  Text(state.errorMessage ?? 'Error loading products', style: AppTextStyles.h3),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => context.read<ProductBloc>().add(const LoadProductsEvent()),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          } else if (state.products.isEmpty && state.status == ProductStatus.success) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const FaIcon(FontAwesomeIcons.boxOpen, size: 64, color: AppColors.textSecondary),
                                  const SizedBox(height: 16),
                                  Text('No products found', style: AppTextStyles.h3),
                                  const SizedBox(height: 8),
                                  Text('Try adjusting your search or filters', style: AppTextStyles.bodyMedium),
                                  const SizedBox(height: 24),
                                  TextButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      context.read<ProductBloc>().add(const ApplyFiltersEvent());
                                    },
                                    child: const Text('Clear all filters'),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ProductListTable(products: state.products);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_showFilters && !isMobile)
              const ProductFilterSidebar(),
          ],
        ),
        floatingActionButton: isMobile
            ? FloatingActionButton(
                onPressed: () => context.push('/dashboard/products/add'),
                backgroundColor: AppColors.primary,
                child: const FaIcon(FontAwesomeIcons.plus, color: Colors.white),
              )
            : null,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Products', style: AppTextStyles.h1),
            const SizedBox(height: 4),
            Text('Manage your marble and granite inventory', 
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)
            ),
          ],
        ),
        if (!isMobile)
          ElevatedButton.icon(
            onPressed: () => context.push('/dashboard/products/add'),
            icon: const FaIcon(FontAwesomeIcons.plus, size: 14),
            label: const Text('Add Product'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
      ],
    );
  }

  Widget _buildActionBar(BuildContext context, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products by name, SKU, material...',
                prefixIcon: const Center(
                  widthFactor: 1.0,
                  child: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 16),
                ),
                suffixIcon: _searchController.text.isNotEmpty 
                  ? IconButton(
                      icon: const FaIcon(FontAwesomeIcons.xmark, size: 14),
                      onPressed: () {
                        _searchController.clear();
                        context.read<ProductBloc>().add(const SearchProductsEvent(''));
                      },
                    )
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                context.read<ProductBloc>().add(SearchProductsEvent(value));
              },
            ),
          ),
          const SizedBox(width: 16),
          _buildActionButton(
            icon: FontAwesomeIcons.filter,
            onPressed: () {
              if (isMobile) {
                _showMobileFilters(context);
              } else {
                setState(() => _showFilters = !_showFilters);
              }
            },
            isSelected: _showFilters,
            label: isMobile ? null : 'Filters',
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            icon: FontAwesomeIcons.sort,
            onPressed: () => _showSortMenu(context),
            label: isMobile ? null : 'Sort',
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            icon: FontAwesomeIcons.download,
            onPressed: () {
              // Export logic
            },
            label: isMobile ? null : 'Export',
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final List<Widget> chips = [];
        
        if (state.categoryId != null) chips.add(_buildFilterChip(context, 'Category: ${state.categoryId}', () => context.read<ProductBloc>().add(ApplyFiltersEvent(categoryId: null))));
        if (state.materialType != null) chips.add(_buildFilterChip(context, 'Material: ${state.materialType}', () => context.read<ProductBloc>().add(ApplyFiltersEvent(materialType: null))));
        if (state.finish != null) chips.add(_buildFilterChip(context, 'Finish: ${state.finish}', () => context.read<ProductBloc>().add(ApplyFiltersEvent(finish: null))));
        if (state.active != null) chips.add(_buildFilterChip(context, state.active! ? 'Active' : 'Inactive', () => context.read<ProductBloc>().add(ApplyFiltersEvent(active: null))));
        if (state.featured != null) chips.add(_buildFilterChip(context, 'Featured', () => context.read<ProductBloc>().add(ApplyFiltersEvent(featured: null))));

        if (chips.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...chips,
              TextButton(
                onPressed: () => context.read<ProductBloc>().add(const ApplyFiltersEvent()),
                child: Text('Clear All', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, VoidCallback onDeleted) {
    return Chip(
      label: Text(label, style: AppTextStyles.bodySmall),
      deleteIcon: const FaIcon(FontAwesomeIcons.xmark, size: 12),
      onDeleted: onDeleted,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: AppColors.border)),
    );
  }

  Widget _buildBulkActionsBar(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.selectedProductIds.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Text('${state.selectedProductIds.length} items selected', 
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)
              ),
              const Spacer(),
              _buildBulkButton(
                icon: FontAwesomeIcons.eye,
                label: 'Activate',
                onPressed: () => context.read<ProductBloc>().add(const BulkUpdateStatusEvent(active: true)),
              ),
              const SizedBox(width: 8),
              _buildBulkButton(
                icon: FontAwesomeIcons.eyeSlash,
                label: 'Deactivate',
                onPressed: () => context.read<ProductBloc>().add(const BulkUpdateStatusEvent(active: false)),
              ),
              const SizedBox(width: 8),
              _buildBulkButton(
                icon: FontAwesomeIcons.star,
                label: 'Feature',
                onPressed: () => context.read<ProductBloc>().add(const BulkUpdateStatusEvent(featured: true)),
              ),
              const SizedBox(width: 8),
              _buildBulkButton(
                icon: FontAwesomeIcons.trashCan,
                label: 'Delete',
                color: AppColors.error,
                onPressed: () => _showBulkDeleteConfirmation(context),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.xmark, size: 16),
                onPressed: () => context.read<ProductBloc>().add(const ClearSelectionEvent()),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBulkButton({required IconData icon, required String label, required VoidCallback onPressed, Color? color}) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: FaIcon(icon, size: 14, color: color ?? AppColors.primary),
      label: Text(label, style: AppTextStyles.bodySmall.copyWith(color: color ?? AppColors.primary, fontWeight: FontWeight.bold)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isSelected = false,
    String? label,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: FaIcon(icon, size: 16, color: isSelected ? AppColors.primary : AppColors.textPrimary),
        label: label != null ? Text(label, style: AppTextStyles.bodyMedium.copyWith(color: isSelected ? AppColors.primary : AppColors.textPrimary)) : const SizedBox.shrink(),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: label != null ? 16 : 8),
        ),
      ),
    );
  }

  void _showMobileFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ProductFilterSidebar(isMobile: true),
    );
  }

  void _showSortMenu(BuildContext context) {
    final bloc = context.read<ProductBloc>();
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 200, 32, 0),
      items: [
        _buildSortItem(bloc, 'name', false, 'Alphabetical (A-Z)'),
        _buildSortItem(bloc, 'name', true, 'Alphabetical (Z-A)'),
        _buildSortItem(bloc, 'price', false, 'Price (Low to High)'),
        _buildSortItem(bloc, 'price', true, 'Price (High to Low)'),
        _buildSortItem(bloc, 'stock', true, 'Stock (High to Low)'),
        _buildSortItem(bloc, 'createdAt', true, 'Newest First'),
        _buildSortItem(bloc, 'createdAt', false, 'Oldest First'),
      ],
    );
  }

  PopupMenuItem _buildSortItem(ProductBloc bloc, String sortBy, bool descending, String label) {
    final isSelected = bloc.state.sortBy == sortBy && bloc.state.descending == descending;
    return PopupMenuItem(
      onTap: () => bloc.add(ChangeSortEvent(sortBy, descending)),
      child: Row(
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: isSelected ? AppColors.primary : AppColors.textPrimary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          if (isSelected) ...[const Spacer(), const FaIcon(FontAwesomeIcons.check, size: 12, color: AppColors.primary)],
        ],
      ),
    );
  }

  void _showBulkDeleteConfirmation(BuildContext context) {
    final bloc = context.read<ProductBloc>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Bulk Delete'),
        content: Text('Are you sure you want to delete ${bloc.state.selectedProductIds.length} products?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              bloc.add(const BulkDeleteProductsEvent());
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}
