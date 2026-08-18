import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

class GetQuoteById {
  final QuoteRepository repository;

  GetQuoteById(this.repository);

  Future<Either<Failure, Quote>> call(String id) async {
    return await repository.getQuoteById(id);
  }
}
