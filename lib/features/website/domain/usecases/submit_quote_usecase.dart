import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/website/domain/repositories/website_repository.dart';

class SubmitQuoteUseCase {
  final WebsiteRepository repository;

  SubmitQuoteUseCase(this.repository);

  Future<Either<Failure, void>> call(Map<String, dynamic> quoteData) async {
    return await repository.submitQuoteRequest(quoteData);
  }
}
