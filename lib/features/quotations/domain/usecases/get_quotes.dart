import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote.dart';
import '../entities/quote_status.dart';
import '../repositories/quote_repository.dart';

class GetQuotes {
  final QuoteRepository repository;

  GetQuotes(this.repository);

  Future<Either<Failure, PaginatedQuotes>> call({
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
  }) async {
    return await repository.getQuotes(
      query: query,
      status: status,
      startDate: startDate,
      endDate: endDate,
      productId: productId,
      categoryId: categoryId,
      sortBy: sortBy,
      descending: descending,
      page: page,
      limit: limit,
    );
  }
}
