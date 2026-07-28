import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/website/domain/entities/product.dart';

abstract class WebsiteRepository {
  Future<Either<Failure, List<Product>>> getFeaturedProducts();
  Future<Either<Failure, void>> submitQuoteRequest(Map<String, dynamic> quoteData);
}
