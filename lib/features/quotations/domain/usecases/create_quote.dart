import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

class CreateQuote {
  final QuoteRepository repository;

  CreateQuote(this.repository);

  Future<Either<Failure, Quote>> call(Quote quote) async {
    return await repository.createQuote(quote);
  }
}
