import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/categories/domain/repositories/category_repository.dart';

class ToggleCategoryStatus {
  final CategoryRepository repository;

  ToggleCategoryStatus(this.repository);

  Future<Either<Failure, bool>> call(String id, bool active) async {
    return await repository.toggleCategoryStatus(id, active);
  }
}
