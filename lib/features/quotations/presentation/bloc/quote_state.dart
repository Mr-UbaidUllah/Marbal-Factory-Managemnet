import 'package:equatable/equatable.dart';
import '../../domain/entities/quote.dart';
import '../../domain/entities/quote_status.dart';

enum QuoteStatusState { initial, loading, success, failure, submitting }

class QuoteState extends Equatable {
  final QuoteStatusState status;
  final List<Quote> quotes;
  final Quote? selectedQuote;
  final String? errorMessage;
  
  // Pagination
  final int totalQuotes;
  final int currentPage;
  final int pageSize;

  // Filters
  final String query;
  final QuoteStatus? filterStatus;
  final DateTime? startDate;
  final DateTime? endDate;
  final String sortBy;
  final bool descending;

  const QuoteState({
    this.status = QuoteStatusState.initial,
    this.quotes = const [],
    this.selectedQuote,
    this.errorMessage,
    this.totalQuotes = 0,
    this.currentPage = 1,
    this.pageSize = 10,
    this.query = '',
    this.filterStatus,
    this.startDate,
    this.endDate,
    this.sortBy = 'createdAt',
    this.descending = true,
  });

  QuoteState copyWith({
    QuoteStatusState? status,
    List<Quote>? quotes,
    Quote? selectedQuote,
    String? errorMessage,
    int? totalQuotes,
    int? currentPage,
    int? pageSize,
    String? query,
    QuoteStatus? filterStatus,
    DateTime? startDate,
    DateTime? endDate,
    String? sortBy,
    bool? descending,
  }) {
    return QuoteState(
      status: status ?? this.status,
      quotes: quotes ?? this.quotes,
      selectedQuote: selectedQuote ?? this.selectedQuote,
      errorMessage: errorMessage ?? this.errorMessage,
      totalQuotes: totalQuotes ?? this.totalQuotes,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      query: query ?? this.query,
      filterStatus: filterStatus ?? this.filterStatus,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sortBy: sortBy ?? this.sortBy,
      descending: descending ?? this.descending,
    );
  }

  int get totalPages => (totalQuotes / pageSize).ceil();

  @override
  List<Object?> get props => [
        status,
        quotes,
        selectedQuote,
        errorMessage,
        totalQuotes,
        currentPage,
        pageSize,
        query,
        filterStatus,
        startDate,
        endDate,
        sortBy,
        descending,
      ];
}
