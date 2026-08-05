import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/exception_mapper.dart';
import 'package:factory_management/features/products/data/datasources/product_remote_datasource.dart';
import 'package:factory_management/features/products/data/models/product_model.dart';
import 'package:factory_management/features/products/domain/entities/product.dart';
import 'package:factory_management/features/products/domain/repositories/product_repository.dart';

import '../../../../core/errors/failures.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaginatedProducts>> getProducts({
    String? query,
    String? categoryId,
    String? materialType,
    String? finish,
    String? color,
    String? originCountry,
    bool? featured,
    bool? active,
    String? sortBy,
    bool? descending,
    int? page,
    int? limit,
  }) async {
    try {
      final result = await remoteDataSource.getProducts(
        query: query,
        categoryId: categoryId,
        materialType: materialType,
        finish: finish,
        color: color,
        originCountry: originCountry,
        featured: featured,
        active: active,
        sortBy: sortBy,
        descending: descending,
        page: page,
        limit: limit,
      );
      
      return Right(PaginatedProducts(
        products: (result['products'] as List).cast<Product>(),
        total: result['total'] as int,
        page: result['page'] as int,
        limit: result['limit'] as int,
      ));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, Product>> getProduct(String id) async {
    try {
      final remoteProduct = await remoteDataSource.getProduct(id);
      return Right(remoteProduct);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(Product product) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      final createdProduct = await remoteDataSource.createProduct(productModel);
      return Right(createdProduct);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      final updatedProduct = await remoteDataSource.updateProduct(productModel);
      return Right(updatedProduct);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(String id) async {
    try {
      final result = await remoteDataSource.deleteProduct(id);
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, bool>> bulkDeleteProducts(List<String> ids) async {
    try {
      final result = await remoteDataSource.bulkDeleteProducts(ids);
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, bool>> bulkUpdateStatus(List<String> ids, {bool? active, bool? featured}) async {
    try {
      final result = await remoteDataSource.bulkUpdateStatus(ids, active: active, featured: featured);
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadImages(List<dynamic> images) async {
    try {
      final imageUrls = await remoteDataSource.uploadImages(images);
      return Right(imageUrls);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }
}
