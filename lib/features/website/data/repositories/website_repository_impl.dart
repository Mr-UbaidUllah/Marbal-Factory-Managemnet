import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/website/data/datasources/website_remote_datasource.dart';
import 'package:factory_management/features/website/domain/entities/product.dart';
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
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitQuoteRequest(Map<String, dynamic> quoteData) async {
    try {
      await remoteDataSource.submitQuoteRequest(quoteData);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
