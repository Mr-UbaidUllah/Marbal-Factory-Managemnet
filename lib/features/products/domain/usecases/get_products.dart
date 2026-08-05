import 'package:dartz/dartz.dart';
import 'package:factory_management/features/products/domain/entities/product.dart';
import 'package:factory_management/features/products/domain/repositories/product_repository.dart';

import '../../../../core/errors/failures.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<Either<Failure, PaginatedProducts>> call({
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
  }) async {
    return await repository.getProducts(
      query: query,
      categoryId: categoryId,
      materialType: materialType,
      finish: finish,
      color: color,
      originCountry: originCountry,
      featured: featured,
      active: active,
      sortBy: sortBy,
      descending: descending,
      page: page,
      limit: limit,
    );
  }
}
