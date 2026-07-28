import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/website/domain/entities/product.dart';
import 'package:factory_management/features/website/domain/repositories/website_repository.dart';

class GetFeaturedProductsUseCase {
  final WebsiteRepository repository;

  GetFeaturedProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getFeaturedProducts();
  }
}
