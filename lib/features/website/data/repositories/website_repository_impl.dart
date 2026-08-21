import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/exception_mapper.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/website/data/datasources/website_remote_datasource.dart';
import 'package:factory_management/features/website/domain/entities/product.dart';
import 'package:factory_management/features/website/domain/entities/project.dart';
import 'package:factory_management/features/website/domain/repositories/website_repository.dart';

class WebsiteRepositoryImpl implements WebsiteRepository {
  final WebsiteRemoteDataSource remoteDataSource;

  WebsiteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getFeaturedProducts() async {
    try {
      final products = await remoteDataSource.getFeaturedProducts();
      return Right(products);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> submitQuoteRequest(Map<String, dynamic> quoteData) async {
    try {
      await remoteDataSource.submitQuoteRequest(quoteData);
      return const Right(null);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, List<Project>>> getProjects() async {
    try {
      final projects = await remoteDataSource.getProjects();
      return Right(projects);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, Project>> getProjectById(String id) async {
    try {
      final project = await remoteDataSource.getProjectById(id);
      return Right(project);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }
}
