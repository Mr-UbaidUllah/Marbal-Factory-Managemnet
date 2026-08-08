import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/categories/domain/entities/category.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_bloc.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_event.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_state.dart';
import 'package:factory_management/features/categories/presentation/widgets/category_list_table.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final TextEditingController _searchController = TextEditingController();

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
      create: (context) => sl<CategoryBloc>()..add(const LoadCategories()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, isMobile),
              const SizedBox(height: 24),
              _buildActionBar(context, isMobile),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state.status == CategoryStatus.loading && state.categories.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.status == CategoryStatus.failure) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(FontAwesomeIcons.circleExclamation, size: 48, color: AppColors.error),
                            const SizedBox(height: 16),
                            Text(state.errorMessage ?? 'Error loading categories', style: AppTextStyles.h3),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context.read<CategoryBloc>().add(const LoadCategories()),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (state.categories.isEmpty && state.status == CategoryStatus.success) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(FontAwesomeIcons.layerGroup, size: 64, color: AppColors.textSecondary),
                            const SizedBox(height: 16),
                            Text('No categories found', style: AppTextStyles.h3),
                            const SizedBox(height: 8),
                            Text('Start by creating your first product category', style: AppTextStyles.bodyMedium),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => context.push('/dashboard/categories/add'),
                              icon: const FaIcon(FontAwesomeIcons.plus, size: 14),
                              label: const Text('Add Category'),
                            ),
                          ],
                        ),
                      );
                    }

                    return CategoryListTable(categories: state.categories);
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: isMobile
            ? FloatingActionButton(
                onPressed: () => context.push('/dashboard/categories/add'),
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
            Text('Categories', style: AppTextStyles.h1),
            const SizedBox(height: 4),
            Text('Organize your products into meaningful groups', 
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)
            ),
          ],
        ),
        if (!isMobile)
          ElevatedButton.icon(
            onPressed: () => context.push('/dashboard/categories/add'),
            icon: const FaIcon(FontAwesomeIcons.plus, size: 14),
            label: const Text('Add Category'),
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
                hintText: 'Search categories by name or description...',
                prefixIcon: const Center(
                  widthFactor: 1.0,
                  child: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 16),
                ),
                suffixIcon: _searchController.text.isNotEmpty 
                  ? IconButton(
                      icon: const FaIcon(FontAwesomeIcons.xmark, size: 14),
                      onPressed: () {
                        _searchController.clear();
                        context.read<CategoryBloc>().add(const SearchCategoriesEvent(''));
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
                context.read<CategoryBloc>().add(SearchCategoriesEvent(value));
              },
            ),
          ),
          const SizedBox(width: 16),
          _buildFilterButton(context),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return PopupMenuButton<bool?>(
          initialValue: state.active,
          onSelected: (value) {
            context.read<CategoryBloc>().add(FilterCategoriesEvent(value));
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: null, child: Text('All Status')),
            const PopupMenuItem(value: true, child: Text('Active Only')),
            const PopupMenuItem(value: false, child: Text('Inactive Only')),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const FaIcon(FontAwesomeIcons.filter, size: 14),
                const SizedBox(width: 8),
                Text(state.active == null ? 'All' : (state.active! ? 'Active' : 'Inactive')),
                const SizedBox(width: 8),
                const FaIcon(FontAwesomeIcons.chevronDown, size: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
