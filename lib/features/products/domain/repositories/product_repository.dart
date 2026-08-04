import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({
    String? categoryId,
    String? searchQuery,
    String? sortBy,
    bool descending = false,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, Product>> getProductById(String id);
  Future<Either<Failure, List<Product>>> getRelatedProducts(String productId);
  Future<Either<Failure, List<Product>>> getFeaturedProducts();
}
