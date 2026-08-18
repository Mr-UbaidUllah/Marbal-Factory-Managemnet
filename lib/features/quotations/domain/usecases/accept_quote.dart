import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

class AcceptQuote {
  final QuoteRepository repository;

  AcceptQuote(this.repository);

  Future<Either<Failure, Quote>> call(String id) async {
    return await repository.acceptQuote(id);
  }
}
