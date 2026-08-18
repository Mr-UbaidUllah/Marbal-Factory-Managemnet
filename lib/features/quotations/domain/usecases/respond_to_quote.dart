import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

class RespondToQuote {
  final QuoteRepository repository;

  RespondToQuote(this.repository);

  Future<Either<Failure, Quote>> call(
    String id, {
    required List<QuoteItemUpdate> items,
    double? discount,
    double? tax,
    double? deliveryCharges,
    required DateTime validUntil,
    String? adminNotes,
  }) async {
    return await repository.respondToQuote(
      id,
      items: items,
      discount: discount,
      tax: tax,
      deliveryCharges: deliveryCharges,
      validUntil: validUntil,
      adminNotes: adminNotes,
    );
  }
}
