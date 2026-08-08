import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/categories/domain/entities/category.dart';
import 'package:factory_management/features/categories/domain/repositories/category_repository.dart';

class GetCategory {
  final CategoryRepository repository;

  GetCategory(this.repository);

  Future<Either<Failure, Category>> call(String id) async {
    return await repository.getCategory(id);
  }
}
