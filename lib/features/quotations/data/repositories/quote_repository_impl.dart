import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/quote.dart';
import '../../domain/entities/quote_item.dart';
import '../../domain/entities/quote_status.dart';
import '../../domain/repositories/quote_repository.dart';
import '../models/quote_model.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  // Mock data storage
  final List<Quote> _mockQuotes = [];

  QuoteRepositoryImpl() {
    _generateMockData();
  }

  void _generateMockData() {
    final now = DateTime.now();
    _mockQuotes.addAll([
      Quote(
        id: '1',
        quoteNumber: 'AMGF-Q-2024-0001',
        requesterName: 'John Doe',
        requesterPhone: '+966 50 123 4567',
        requesterEmail: 'john@example.com',
        requesterAddress: 'Riyadh, Saudi Arabia',
        status: QuoteStatus.pending,
        items: const [
          QuoteItem(
            id: 'i1',
            quoteId: '1',
            productId: 'p1',
            productName: 'Italian Carrara Marble',
            sku: 'MAR-ITA-001',
            categoryId: 'cat1',
            categoryName: 'Marble',
            quantity: 50,
            unit: 'sqm',
            quotedPrice: 0,
            notes: 'Need high quality finish',
          ),
        ],
        subtotal: 0,
        discount: 0,
        tax: 0,
        deliveryCharges: 0,
        total: 0,
        customerNotes: 'Please provide best price for bulk order.',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      Quote(
        id: '2',
        quoteNumber: 'AMGF-Q-2024-0002',
        requesterName: 'Jane Smith',
        requesterPhone: '+966 55 987 6543',
        status: QuoteStatus.quoted,
        items: const [
          QuoteItem(
            id: 'i2',
            quoteId: '2',
            productId: 'p2',
            productName: 'Black Galaxy Granite',
            sku: 'GRA-IND-002',
            categoryId: 'cat2',
            categoryName: 'Granite',
            quantity: 30,
            unit: 'sqm',
            quotedPrice: 250,
          ),
        ],
        subtotal: 7500,
        discount: 500,
        tax: 1050,
        deliveryCharges: 200,
        total: 8250,
        validUntil: now.add(const Duration(days: 15)),
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 1)),
        respondedAt: now.subtract(const Duration(days: 1)),
      ),
    ]);
  }

  @override
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
  }) async {
    try {
      var filtered = _mockQuotes.where((q) {
        if (query != null && query.isNotEmpty) {
          final ql = query.toLowerCase();
          if (!q.quoteNumber.toLowerCase().contains(ql) &&
              !q.requesterName.toLowerCase().contains(ql) &&
              !(q.requesterEmail?.toLowerCase().contains(ql) ?? false)) {
            return false;
          }
        }
        if (status != null && q.status != status) return false;
        return true;
      }).toList();

      // Simple sorting
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      if (!descending) {
        filtered = filtered.reversed.toList();
      }

      final start = (page - 1) * limit;
      final end = start + limit;
      final paginated = filtered.sublist(
        start.clamp(0, filtered.length),
        end.clamp(0, filtered.length),
      );

      return Right(PaginatedQuotes(
        quotes: paginated,
        total: filtered.length,
        page: page,
        limit: limit,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Quote>> getQuoteById(String id) async {
    try {
      final quote = _mockQuotes.firstWhere((q) => q.id == id);
      return Right(quote);
    } catch (e) {
      return const Left(ServerFailure('Quote not found'));
    }
  }

  @override
  Future<Either<Failure, Quote>> createQuote(Quote quote) async {
    try {
      final newQuote = QuoteModel.fromEntity(quote).copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        quoteNumber: 'AMGF-Q-${DateTime.now().year}-${_mockQuotes.length + 1001}',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _mockQuotes.add(newQuote);
      return Right(newQuote);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Quote>> updateQuote(Quote quote) async {
    try {
      final index = _mockQuotes.indexWhere((q) => q.id == quote.id);
      if (index == -1) return const Left(ServerFailure('Quote not found'));
      
      final updated = QuoteModel.fromEntity(quote).copyWith(updatedAt: DateTime.now());
      _mockQuotes[index] = updated;
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Quote>> submitQuote(String id) async {
    return _updateStatus(id, QuoteStatus.pending);
  }

  @override
  Future<Either<Failure, Quote>> reviewQuote(String id, {String? adminNotes}) async {
    try {
      final index = _mockQuotes.indexWhere((q) => q.id == id);
      if (index == -1) return const Left(ServerFailure('Quote not found'));
      
      final current = _mockQuotes[index];
      if (!current.status.canTransitionTo(QuoteStatus.underReview)) {
        return const Left(ValidationFailure('Invalid status transition'));
      }

      final updated = current.copyWith(
        status: QuoteStatus.underReview,
        adminNotes: adminNotes,
        updatedAt: DateTime.now(),
      );
      _mockQuotes[index] = updated;
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Quote>> respondToQuote(
    String id, {
    required List<QuoteItemUpdate> items,
    double? discount,
    double? tax,
    double? deliveryCharges,
    required DateTime validUntil,
    String? adminNotes,
  }) async {
    try {
      final index = _mockQuotes.indexWhere((q) => q.id == id);
      if (index == -1) return const Left(ServerFailure('Quote not found'));
      
      final current = _mockQuotes[index];
      
      final updatedItems = current.items.map((item) {
        final update = items.firstWhere((u) => u.itemId == item.id, orElse: () => QuoteItemUpdate(itemId: item.id, quotedPrice: item.quotedPrice));
        return item.copyWith(
          quotedPrice: update.quotedPrice,
          discount: update.discount,
        );
      }).toList();

      // Calculation logic would ideally be in a service, used here for mock
      double subtotal = 0;
      for (var item in updatedItems) {
        subtotal += item.quantity * item.quotedPrice;
      }

      final updated = current.copyWith(
        items: updatedItems,
        status: QuoteStatus.quoted,
        subtotal: subtotal,
        discount: discount ?? current.discount,
        tax: tax ?? current.tax,
        deliveryCharges: deliveryCharges ?? current.deliveryCharges,
        total: subtotal - (discount ?? 0) + (tax ?? 0) + (deliveryCharges ?? 0),
        validUntil: validUntil,
        adminNotes: adminNotes,
        respondedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      _mockQuotes[index] = updated;
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Quote>> acceptQuote(String id) async {
    try {
      final index = _mockQuotes.indexWhere((q) => q.id == id);
      if (index == -1) return const Left(ServerFailure('Quote not found'));
      
      final current = _mockQuotes[index];
      
      if (current.validUntil != null && current.validUntil!.isBefore(DateTime.now())) {
        return const Left(ValidationFailure('Quote has expired'));
      }

      if (!current.status.canTransitionTo(QuoteStatus.accepted)) {
        return const Left(ValidationFailure('Invalid status transition'));
      }

      final updated = current.copyWith(
        status: QuoteStatus.accepted,
        acceptedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _mockQuotes[index] = updated;
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Quote>> rejectQuote(String id, {required String reason}) async {
    try {
      final index = _mockQuotes.indexWhere((q) => q.id == id);
      if (index == -1) return const Left(ServerFailure('Quote not found'));
      
      final current = _mockQuotes[index];
      
      final updated = current.copyWith(
        status: QuoteStatus.rejected,
        rejectedAt: DateTime.now(),
        rejectionReason: reason,
        updatedAt: DateTime.now(),
      );
      _mockQuotes[index] = updated;
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Quote>> cancelQuote(String id) async {
    return _updateStatus(id, QuoteStatus.cancelled);
  }

  Future<Either<Failure, Quote>> _updateStatus(String id, QuoteStatus status) async {
     try {
      final index = _mockQuotes.indexWhere((q) => q.id == id);
      if (index == -1) return const Left(ServerFailure('Quote not found'));
      
      final current = _mockQuotes[index];
      final updated = current.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      _mockQuotes[index] = updated;
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
