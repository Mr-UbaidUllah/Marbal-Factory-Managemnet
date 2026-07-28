import 'package:factory_management/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({
    String? categoryId,
    String? searchQuery,
    String? sortBy,
    bool descending = false,
    int page = 1,
    int limit = 20,
  });

  Future<Product> getProductById(String id);
  Future<List<Product>> getRelatedProducts(String productId);
  Future<List<Product>> getFeaturedProducts();
}
