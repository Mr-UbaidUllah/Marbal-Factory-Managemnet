import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/core/errors/exception_mapper.dart';
import 'package:factory_management/features/categories/data/datasources/category_remote_datasource.dart';
import 'package:factory_management/features/categories/data/models/category_model.dart';
import 'package:factory_management/features/categories/domain/entities/category.dart';
import 'package:factory_management/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Category>>> getCategories({
    String? query,
    bool? active,
    String? parentId,
  }) async {
    try {
      final remoteCategories = await remoteDataSource.getCategories(
        query: query,
        active: active,
        parentId: parentId,
      );
      return Right(remoteCategories);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, Category>> getCategory(String id) async {
    try {
      final remoteCategory = await remoteDataSource.getCategory(id);
      return Right(remoteCategory);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, Category>> createCategory(Category category) async {
    try {
      final model = CategoryModel.fromEntity(category);
      final createdCategory = await remoteDataSource.createCategory(model);
      return Right(createdCategory);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, Category>> updateCategory(Category category) async {
    try {
      final model = CategoryModel.fromEntity(category);
      final updatedCategory = await remoteDataSource.updateCategory(model);
      return Right(updatedCategory);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCategory(String id) async {
    try {
      final result = await remoteDataSource.deleteCategory(id);
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleCategoryStatus(String id, bool active) async {
    try {
      final result = await remoteDataSource.toggleCategoryStatus(id, active);
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, bool>> reorderCategories(List<String> orderedIds) async {
    try {
      final result = await remoteDataSource.reorderCategories(orderedIds);
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }
}
