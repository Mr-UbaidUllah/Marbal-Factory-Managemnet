import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_quotes.dart';
import '../../domain/usecases/get_quote_by_id.dart';
import '../../domain/usecases/create_quote.dart';
import '../../domain/usecases/review_quote.dart';
import '../../domain/usecases/respond_to_quote.dart';
import '../../domain/usecases/accept_quote.dart';
import '../../domain/usecases/reject_quote.dart';
import '../../domain/usecases/cancel_quote.dart';
import 'quote_event.dart';
import 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final GetQuotes getQuotes;
  final GetQuoteById getQuoteById;
  final CreateQuote createQuote;
  final ReviewQuote reviewQuote;
  final RespondToQuote respondToQuote;
  final AcceptQuote acceptQuote;
  final RejectQuote rejectQuote;
  final CancelQuote cancelQuote;

  QuoteBloc({
    required this.getQuotes,
    required this.getQuoteById,
    required this.createQuote,
    required this.reviewQuote,
    required this.respondToQuote,
    required this.acceptQuote,
    required this.rejectQuote,
    required this.cancelQuote,
  }) : super(const QuoteState()) {
    on<LoadQuotes>(_onLoadQuotes);
    on<SearchQuotes>(_onSearchQuotes);
    on<FilterQuotes>(_onFilterQuotes);
    on<ChangeQuotePage>(_onChangeQuotePage);
    on<GetQuoteDetail>(_onGetQuoteDetail);
    on<CreateQuoteEvent>(_onCreateQuote);
    on<ReviewQuoteEvent>(_onReviewQuote);
    on<RespondToQuoteEvent>(_onRespondToQuote);
    on<AcceptQuoteEvent>(_onAcceptQuote);
    on<RejectQuoteEvent>(_onRejectQuote);
    on<CancelQuoteEvent>(_onCancelQuote);
  }

  Future<void> _onLoadQuotes(LoadQuotes event, Emitter<QuoteState> emit) async {
    emit(state.copyWith(status: QuoteStatusState.loading));
    
    final result = await getQuotes(
      query: state.query,
      status: state.filterStatus,
      startDate: state.startDate,
      endDate: state.endDate,
      page: state.currentPage,
      limit: state.pageSize,
      sortBy: state.sortBy,
      descending: state.descending,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: QuoteStatusState.failure,
        errorMessage: failure.message,
      )),
      (paginated) => emit(state.copyWith(
        status: QuoteStatusState.success,
        quotes: paginated.quotes,
        totalQuotes: paginated.total,
      )),
    );
  }

  Future<void> _onSearchQuotes(SearchQuotes event, Emitter<QuoteState> emit) async {
    emit(state.copyWith(query: event.query, currentPage: 1));
    add(const LoadQuotes());
  }

  Future<void> _onFilterQuotes(FilterQuotes event, Emitter<QuoteState> emit) async {
    emit(state.copyWith(
      filterStatus: event.status,
      startDate: event.startDate,
      endDate: event.endDate,
      currentPage: 1,
    ));
    add(const LoadQuotes());
  }

  Future<void> _onChangeQuotePage(ChangeQuotePage event, Emitter<QuoteState> emit) async {
    emit(state.copyWith(currentPage: event.page));
    add(const LoadQuotes());
  }

  Future<void> _onGetQuoteDetail(GetQuoteDetail event, Emitter<QuoteState> emit) async {
    emit(state.copyWith(status: QuoteStatusState.loading));
    final result = await getQuoteById(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: QuoteStatusState.failure,
        errorMessage: failure.message,
      )),
      (quote) => emit(state.copyWith(
        status: QuoteStatusState.success,
        selectedQuote: quote,
      )),
    );
  }

  Future<void> _onCreateQuote(CreateQuoteEvent event, Emitter<QuoteState> emit) async {
    emit(state.copyWith(status: QuoteStatusState.submitting));
    final result = await createQuote(event.quote);
    result.fold(
      (failure) => emit(state.copyWith(
        status: QuoteStatusState.failure,
        errorMessage: failure.message,
      )),
      (quote) => emit(state.copyWith(
        status: QuoteStatusState.success,
        selectedQuote: quote,
      )),
    );
  }

  Future<void> _onReviewQuote(ReviewQuoteEvent event, Emitter<QuoteState> emit) async {
    emit(state.copyWith(status: QuoteStatusState.submitting));
    final result = await reviewQuote(event.id, adminNotes: event.adminNotes);
    result.fold(
      (failure) => emit(state.copyWith(
        status: QuoteStatusState.failure,
        errorMessage: failure.message,
      )),
      (quote) => emit(state.copyWith(
        status: QuoteStatusState.success,
        selectedQuote: quote,
      )),
    );
  }

  Future<void> _onRespondToQuote(RespondToQuoteEvent event, Emitter<QuoteState> emit) async {
    emit(state.copyWith(status: QuoteStatusState.submitting));
    final result = await respondToQuote(
      event.id,
      items: event.items,
      discount: event.discount,
      tax: event.tax,
      deliveryCharges: event.deliveryCharges,
      validUntil: event.validUntil,
      adminNotes: event.adminNotes,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: QuoteStatusState.failure,
        errorMessage: failure.message,
      )),
      (quote) => emit(state.copyWith(
        status: QuoteStatusState.success,
        selectedQuote: quote,
      )),
    );
  }

  Future<void> _onAcceptQuote(AcceptQuoteEvent event, Emitter<QuoteState> emit) async {
    emit(state.copyWith(status: QuoteStatusState.submitting));
    final result = await acceptQuote(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: QuoteStatusState.failure,
        errorMessage: failure.message,
      )),
      (quote) => emit(state.copyWith(
        status: QuoteStatusState.success,
        selectedQuote: quote,
      )),
    );
  }

  Future<void> _onRejectQuote(RejectQuoteEvent event, Emitter<QuoteState> emit) async {
    emit(state.copyWith(status: QuoteStatusState.submitting));
    final result = await rejectQuote(event.id, reason: event.reason);
    result.fold(
      (failure) => emit(state.copyWith(
        status: QuoteStatusState.failure,
        errorMessage: failure.message,
      )),
      (quote) => emit(state.copyWith(
        status: QuoteStatusState.success,
        selectedQuote: quote,
      )),
    );
  }

  Future<void> _onCancelQuote(CancelQuoteEvent event, Emitter<QuoteState> emit) async {
    emit(state.copyWith(status: QuoteStatusState.submitting));
    final result = await cancelQuote(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: QuoteStatusState.failure,
        errorMessage: failure.message,
      )),
      (quote) => emit(state.copyWith(
        status: QuoteStatusState.success,
        selectedQuote: quote,
      )),
    );
  }
}
