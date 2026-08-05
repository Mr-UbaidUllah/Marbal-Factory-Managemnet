import 'package:equatable/equatable.dart';
import 'package:factory_management/features/products/domain/entities/product.dart';
import 'package:factory_management/features/products/domain/repositories/product_repository.dart';

enum ProductStatus { initial, loading, success, failure }

class ProductState extends Equatable {
  final ProductStatus status;
  final List<Product> products;
  final Product? selectedProduct;
  final String? errorMessage;
  final bool isSubmitting;
  
  // Pagination
  final int totalProducts;
  final int currentPage;
  final int pageSize;
  
  // Selection for bulk operations
  final Set<String> selectedProductIds;

  // Filters & Search
  final String query;
  final String? categoryId;
  final String? materialType;
  final String? finish;
  final String? color;
  final String? originCountry;
  final bool? featured;
  final bool? active;
  final String sortBy;
  final bool descending;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.selectedProduct,
    this.errorMessage,
    this.isSubmitting = false,
    this.totalProducts = 0,
    this.currentPage = 1,
    this.pageSize = 10,
    this.selectedProductIds = const {},
    this.query = '',
    this.categoryId,
    this.materialType,
    this.finish,
    this.color,
    this.originCountry,
    this.featured,
    this.active,
    this.sortBy = 'createdAt',
    this.descending = true,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? products,
    Product? selectedProduct,
    String? errorMessage,
    bool? isSubmitting,
    int? totalProducts,
    int? currentPage,
    int? pageSize,
    Set<String>? selectedProductIds,
    String? query,
    String? categoryId,
    String? materialType,
    String? finish,
    String? color,
    String? originCountry,
    bool? featured,
    bool? active,
    String? sortBy,
    bool? descending,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      errorMessage: errorMessage ?? this.errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      totalProducts: totalProducts ?? this.totalProducts,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      selectedProductIds: selectedProductIds ?? this.selectedProductIds,
      query: query ?? this.query,
      categoryId: categoryId ?? this.categoryId,
      materialType: materialType ?? this.materialType,
      finish: finish ?? this.finish,
      color: color ?? this.color,
      originCountry: originCountry ?? this.originCountry,
      featured: featured ?? this.featured,
      active: active ?? this.active,
      sortBy: sortBy ?? this.sortBy,
      descending: descending ?? this.descending,
    );
  }

  int get totalPages => (totalProducts / pageSize).ceil();

  @override
  List<Object?> get props => [
        status,
        products,
        selectedProduct,
        errorMessage,
        isSubmitting,
        totalProducts,
        currentPage,
        pageSize,
        selectedProductIds,
        query,
        categoryId,
        materialType,
        finish,
        color,
        originCountry,
        featured,
        active,
        sortBy,
        descending,
      ];
}
