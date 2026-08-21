import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_bloc.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_event.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_state.dart';
import 'package:factory_management/features/website/presentation/widgets/website_navbar.dart';
import 'package:factory_management/features/website/presentation/widgets/website_footer.dart';
import 'package:factory_management/features/website/presentation/widgets/website_category_card.dart';

class WebsiteCategoriesPage extends StatefulWidget {
  const WebsiteCategoriesPage({super.key});

  @override
  State<WebsiteCategoriesPage> createState() => _WebsiteCategoriesPageState();
}

class _WebsiteCategoriesPageState extends State<WebsiteCategoriesPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

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
    return BlocProvider(
      create: (context) => sl<CategoryBloc>()..add(const LoadCategories(active: true)),
      child: Scaffold(
        appBar: WebsiteNavbar(isScrolled: _isScrolled),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      _buildCategoryGrid(context),
                    ],
                  ),
                ),
              ),
              const WebsiteFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?q=80&w=2070&auto=format&fit=crop'),
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "OUR COLLECTIONS",
              style: AppTextStyles.label.copyWith(
                color: AppColors.gold,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Browse by Category",
              style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 48),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state.status == CategoryStatus.loading) {
          return _buildLoadingState();
        }

        if (state.status == CategoryStatus.failure) {
          return _buildErrorState(context, state.errorMessage);
        }

        final categories = state.categories.where((c) => c.active).toList();

        if (categories.isEmpty) {
          return _buildEmptyState(context);
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 3;
            if (constraints.maxWidth < 600) {
              crossAxisCount = 1;
            } else if (constraints.maxWidth < 950) {
              crossAxisCount = 2;
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                childAspectRatio: 0.85,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return WebsiteCategoryCard(category: categories[index]);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        childAspectRatio: 0.85,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.category_outlined, size: 80, color: AppColors.textTertiary),
        const SizedBox(height: 20),
        Text("No categories found.", style: AppTextStyles.h3),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => context.go('/products'),
          child: const Text("Explore All Products"),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    return Column(
      children: [
        const Icon(Icons.error_outline, size: 80, color: Colors.red),
        const SizedBox(height: 20),
        Text(message ?? "Failed to load categories", style: AppTextStyles.h3),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => context.read<CategoryBloc>().add(const LoadCategories(active: true)),
          child: const Text("Retry"),
        ),
      ],
    );
  }
}
