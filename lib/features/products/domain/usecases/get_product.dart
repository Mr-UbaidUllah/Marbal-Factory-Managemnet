import 'package:dartz/dartz.dart';
import 'package:factory_management/features/products/domain/entities/product.dart';
import 'package:factory_management/features/products/domain/repositories/product_repository.dart';

import '../../../../core/errors/failures.dart';

class GetProduct {
  final ProductRepository repository;

  GetProduct(this.repository);

  Future<Either<Failure, Product>> call(String id) async {
    return await repository.getProduct(id);
  }
}
