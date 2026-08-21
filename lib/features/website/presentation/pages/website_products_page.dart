import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/products/presentation/bloc/product_bloc.dart';
import 'package:factory_management/features/products/presentation/bloc/product_event.dart';
import 'package:factory_management/features/products/presentation/bloc/product_state.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_bloc.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_event.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_state.dart';
import 'package:factory_management/features/website/presentation/widgets/website_navbar.dart';
import 'package:factory_management/features/website/presentation/widgets/website_footer.dart';
import 'package:factory_management/features/website/presentation/widgets/website_product_card.dart';

class WebsiteProductsPage extends StatefulWidget {
  final String? initialCategoryId;
  
  const WebsiteProductsPage({super.key, this.initialCategoryId});

  @override
  State<WebsiteProductsPage> createState() => _WebsiteProductsPageState();
}

class _WebsiteProductsPageState extends State<WebsiteProductsPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
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
    _searchController.dispose();
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
          create: (context) => sl<ProductBloc>()..add(ApplyFiltersEvent(
            active: true, 
            categoryId: widget.initialCategoryId,
          )),
        ),
        BlocProvider(
          create: (context) => sl<CategoryBloc>()..add(const LoadCategories(active: true)),
        ),
      ],
      child: Scaffold(
        appBar: WebsiteNavbar(isScrolled: _isScrolled),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
                child: Column(
                  children: [
                    _buildFilters(context),
                    const SizedBox(height: 40),
                    _buildProductGrid(context),
                  ],
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
          image: NetworkImage('https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=2070&auto=format&fit=crop'),
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "OUR PRODUCTS",
              style: AppTextStyles.label.copyWith(
                color: AppColors.gold,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Premium Marble & Granite",
              style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 48),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, productState) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search by name, SKU, or material...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                      ),
                      onChanged: (value) {
                        context.read<ProductBloc>().add(SearchProductsEvent(value));
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, catState) {
                        return DropdownButtonFormField<String>(
                          value: productState.categoryId,
                          decoration: InputDecoration(
                            hintText: "All Categories",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: [
                            const DropdownMenuItem(value: null, child: Text("All Categories")),
                            ...catState.categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
                          ],
                          onChanged: (value) {
                            context.read<ProductBloc>().add(ApplyFiltersEvent(categoryId: value, active: true));
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: productState.sortBy,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'createdAt', child: Text("Newest")),
                        DropdownMenuItem(value: 'name', child: Text("Name A-Z")),
                        DropdownMenuItem(value: 'price', child: Text("Price")),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          context.read<ProductBloc>().add(ChangeSortEvent(value, productState.descending));
                        }
                      },
                    ),
                  ),
                ],
              ),
              if (productState.query.isNotEmpty || productState.categoryId != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Text(
                        "${productState.totalProducts} products found",
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          _searchController.clear();
                          context.read<ProductBloc>().add(const ApplyFiltersEvent(active: true));
                        },
                        child: const Text("Clear All Filters"),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.status == ProductStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state.status == ProductStatus.failure) {
          return Center(child: Text(state.errorMessage ?? "Failed to load products"));
        }

        if (state.products.isEmpty) {
          return Column(
            children: [
              const Icon(Icons.search_off, size: 80, color: AppColors.textTertiary),
              const SizedBox(height: 20),
              Text("No products found matching your criteria.", style: AppTextStyles.h3),
            ],
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
              itemCount: state.products.length,
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
