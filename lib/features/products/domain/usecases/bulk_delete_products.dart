import 'package:dartz/dartz.dart';
import 'package:factory_management/features/products/domain/repositories/product_repository.dart';
import '../../../../core/errors/failures.dart';

class BulkDeleteProducts {
  final ProductRepository repository;

  BulkDeleteProducts(this.repository);

  Future<Either<Failure, bool>> call(List<String> ids) async {
    return await repository.bulkDeleteProducts(ids);
  }
}
