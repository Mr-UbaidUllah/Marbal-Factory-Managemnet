import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/categories/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getCategories({
    String? query,
    bool? active,
    String? parentId,
  });

  Future<Either<Failure, Category>> getCategory(String id);

  Future<Either<Failure, Category>> createCategory(Category category);

  Future<Either<Failure, Category>> updateCategory(Category category);

  Future<Either<Failure, bool>> deleteCategory(String id);

  Future<Either<Failure, bool>> toggleCategoryStatus(String id, bool active);

  Future<Either<Failure, bool>> reorderCategories(List<String> orderedIds);
}
