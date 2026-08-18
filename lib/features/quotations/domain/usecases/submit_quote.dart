import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

class SubmitQuote {
  final QuoteRepository repository;

  SubmitQuote(this.repository);

  Future<Either<Failure, Quote>> call(String id) async {
    return await repository.submitQuote(id);
  }
}
