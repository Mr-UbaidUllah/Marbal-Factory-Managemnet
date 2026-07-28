import 'package:factory_management/features/products/domain/entities/product.dart';
import 'package:factory_management/features/products/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<Product>> call({
    String? categoryId,
    String? searchQuery,
    String? sortBy,
    bool descending = false,
    int page = 1,
    int limit = 20,
  }) {
    return repository.getProducts(
      categoryId: categoryId,
      searchQuery: searchQuery,
      sortBy: sortBy,
      descending: descending,
      page: page,
      limit: limit,
    );
  }
}
