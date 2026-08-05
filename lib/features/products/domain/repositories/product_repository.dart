import 'package:dartz/dartz.dart';
import 'package:factory_management/features/products/domain/entities/product.dart';

import '../../../../core/errors/failures.dart';

class PaginatedProducts {
  final List<Product> products;
  final int total;
  final int page;
  final int limit;

  PaginatedProducts({
    required this.products,
    required this.total,
    required this.page,
    required this.limit,
  });

  int get totalPages => (total / limit).ceil();
}

abstract class ProductRepository {
  Future<Either<Failure, PaginatedProducts>> getProducts({
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
    int? page,
    int? limit,
  });

  Future<Either<Failure, Product>> getProduct(String id);

  Future<Either<Failure, Product>> createProduct(Product product);

  Future<Either<Failure, Product>> updateProduct(Product product);

  Future<Either<Failure, bool>> deleteProduct(String id);

  Future<Either<Failure, bool>> bulkDeleteProducts(List<String> ids);

  Future<Either<Failure, bool>> bulkUpdateStatus(List<String> ids, {bool? active, bool? featured});

  Future<Either<Failure, List<String>>> uploadImages(List<dynamic> images);
}
