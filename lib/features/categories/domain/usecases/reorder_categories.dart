import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/categories/domain/repositories/category_repository.dart';

class ReorderCategories {
  final CategoryRepository repository;

  ReorderCategories(this.repository);

  Future<Either<Failure, bool>> call(List<String> orderedIds) async {
    return await repository.reorderCategories(orderedIds);
  }
}
