import 'package:dartz/dartz.dart';
import 'package:factory_management/features/products/domain/repositories/product_repository.dart';
import '../../../../core/errors/failures.dart';

class BulkUpdateStatus {
  final ProductRepository repository;

  BulkUpdateStatus(this.repository);

  Future<Either<Failure, bool>> call(List<String> ids, {bool? active, bool? featured}) async {
    return await repository.bulkUpdateStatus(ids, active: active, featured: featured);
  }
}
