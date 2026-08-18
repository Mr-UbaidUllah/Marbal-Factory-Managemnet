import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

class ReviewQuote {
  final QuoteRepository repository;

  ReviewQuote(this.repository);

  Future<Either<Failure, Quote>> call(String id, {String? adminNotes}) async {
    return await repository.reviewQuote(id, adminNotes: adminNotes);
  }
}
