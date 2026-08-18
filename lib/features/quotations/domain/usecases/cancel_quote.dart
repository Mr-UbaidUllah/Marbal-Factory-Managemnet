import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

class CancelQuote {
  final QuoteRepository repository;

  CancelQuote(this.repository);

  Future<Either<Failure, Quote>> call(String id) async {
    return await repository.cancelQuote(id);
  }
}
