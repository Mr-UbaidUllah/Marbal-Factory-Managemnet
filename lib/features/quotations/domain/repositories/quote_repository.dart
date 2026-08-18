import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote.dart';
import '../entities/quote_status.dart';

class PaginatedQuotes {
  final List<Quote> quotes;
  final int total;
  final int page;
  final int limit;

  PaginatedQuotes({
    required this.quotes,
    required this.total,
    required this.page,
    required this.limit,
  });

  int get totalPages => (total / limit).ceil();
}

abstract class QuoteRepository {
  Future<Either<Failure, PaginatedQuotes>> getQuotes({
    String? query,
    QuoteStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    String? productId,
    String? categoryId,
    String? sortBy,
    bool descending = true,
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, Quote>> getQuoteById(String id);

  Future<Either<Failure, Quote>> createQuote(Quote quote);

  Future<Either<Failure, Quote>> updateQuote(Quote quote);

  Future<Either<Failure, Quote>> submitQuote(String id);

  Future<Either<Failure, Quote>> reviewQuote(String id, {String? adminNotes});

  Future<Either<Failure, Quote>> respondToQuote(
    String id, {
    required List<QuoteItemUpdate> items,
    double? discount,
    double? tax,
    double? deliveryCharges,
    required DateTime validUntil,
    String? adminNotes,
  });

  Future<Either<Failure, Quote>> acceptQuote(String id);

  Future<Either<Failure, Quote>> rejectQuote(String id, {required String reason});

  Future<Either<Failure, Quote>> cancelQuote(String id);
}

class QuoteItemUpdate {
  final String itemId;
  final double quotedPrice;
  final double discount;

  QuoteItemUpdate({
    required this.itemId,
    required this.quotedPrice,
    this.discount = 0.0,
  });
}
