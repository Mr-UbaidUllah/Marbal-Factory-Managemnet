import 'package:dartz/dartz.dart';
import 'package:factory_management/features/products/domain/repositories/product_repository.dart';

import '../../../../core/errors/failures.dart';

class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  Future<Either<Failure, bool>> call(String id) async {
    return await repository.deleteProduct(id);
  }
}
