import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

class RejectQuote {
  final QuoteRepository repository;

  RejectQuote(this.repository);

  Future<Either<Failure, Quote>> call(String id, {required String reason}) async {
    return await repository.rejectQuote(id, reason: reason);
  }
}
