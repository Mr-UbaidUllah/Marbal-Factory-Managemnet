import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/categories/domain/entities/category.dart';
import 'package:factory_management/features/categories/domain/repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository repository;

  GetCategories(this.repository);

  Future<Either<Failure, List<Category>>> call({
    String? query,
    bool? active,
    String? parentId,
  }) async {
    return await repository.getCategories(
      query: query,
      active: active,
      parentId: parentId,
    );
  }
}
