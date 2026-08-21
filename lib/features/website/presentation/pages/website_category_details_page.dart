import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_bloc.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_event.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_state.dart';
import 'package:factory_management/features/products/presentation/bloc/product_bloc.dart';
import 'package:factory_management/features/products/presentation/bloc/product_event.dart';
import 'package:factory_management/features/products/presentation/bloc/product_state.dart';
import 'package:factory_management/features/website/presentation/widgets/website_navbar.dart';
import 'package:factory_management/features/website/presentation/widgets/website_footer.dart';
import 'package:factory_management/features/website/presentation/widgets/website_product_card.dart';
import 'package:factory_management/core/router/route_paths.dart';

class WebsiteCategoryDetailsPage extends StatefulWidget {
  final String categoryId;
  const WebsiteCategoryDetailsPage({super.key, required this.categoryId});

  @override
  State<WebsiteCategoryDetailsPage> createState() => _WebsiteCategoryDetailsPageState();
}

class _WebsiteCategoryDetailsPageState extends State<WebsiteCategoryDetailsPage> {
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<CategoryBloc>()..add(GetCategoryEvent(widget.categoryId)),
        ),
        BlocProvider(
          create: (context) => sl<ProductBloc>()..add(ApplyFiltersEvent(
            categoryId: widget.categoryId,
            active: true,
          )),
        ),
      ],
      child: Scaffold(
        appBar: WebsiteNavbar(isScrolled: _isScrolled),
        body: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state.status == CategoryStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == CategoryStatus.failure) {
              return Center(child: Text(state.errorMessage ?? "Category not found"));
            }

            final category = state.selectedCategory;
            if (category == null) {
              return const Center(child: Text("Category not found"));
            }

            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  _buildHeader(context, category),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Available Products",
                                style: AppTextStyles.h2,
                              ),
                              ElevatedButton(
                                onPressed: () => context.go('${RoutePaths.products}?category=${category.id}'),
                                child: const Text("View All Products"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          _buildProductGrid(context),
                        ],
                      ),
                    ),
                  ),
                  const WebsiteFooter(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic category) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        image: category.image != null && category.image!.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(category.image!),
                fit: BoxFit.cover,
                opacity: 0.4,
              )
            : null,
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "COLLECTION",
                style: AppTextStyles.label.copyWith(
                  color: AppColors.gold,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 56),
              ),
              if (category.description != null) ...[
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Text(
                    category.description!,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(color: Colors.white70),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.status == ProductStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.products.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Column(
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textTertiary),
                  const SizedBox(height: 16),
                  Text("No products found in this category.", style: AppTextStyles.h3),
                ],
              ),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 4;
            if (constraints.maxWidth < 600) {
              crossAxisCount = 2;
            } else if (constraints.maxWidth < 1000) {
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
              itemCount: state.products.take(8).length,
              itemBuilder: (context, index) {
                return WebsiteProductCard(product: state.products[index]);
              },
            );
          },
        );
      },
    );
  }
}
