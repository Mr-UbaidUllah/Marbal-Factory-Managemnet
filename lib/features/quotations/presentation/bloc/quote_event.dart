import 'package:equatable/equatable.dart';
import '../../domain/entities/quote.dart';
import '../../domain/entities/quote_status.dart';
import '../../domain/repositories/quote_repository.dart';

abstract class QuoteEvent extends Equatable {
  const QuoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuotes extends QuoteEvent {
  final bool refresh;
  const LoadQuotes({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class SearchQuotes extends QuoteEvent {
  final String query;
  const SearchQuotes(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterQuotes extends QuoteEvent {
  final QuoteStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;
  const FilterQuotes({this.status, this.startDate, this.endDate});

  @override
  List<Object?> get props => [status, startDate, endDate];
}

class ChangeQuotePage extends QuoteEvent {
  final int page;
  const ChangeQuotePage(this.page);

  @override
  List<Object?> get props => [page];
}

class GetQuoteDetail extends QuoteEvent {
  final String id;
  const GetQuoteDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateQuoteEvent extends QuoteEvent {
  final Quote quote;
  const CreateQuoteEvent(this.quote);

  @override
  List<Object?> get props => [quote];
}

class ReviewQuoteEvent extends QuoteEvent {
  final String id;
  final String? adminNotes;
  const ReviewQuoteEvent(this.id, {this.adminNotes});

  @override
  List<Object?> get props => [id, adminNotes];
}

class RespondToQuoteEvent extends QuoteEvent {
  final String id;
  final List<QuoteItemUpdate> items;
  final double? discount;
  final double? tax;
  final double? deliveryCharges;
  final DateTime validUntil;
  final String? adminNotes;

  const RespondToQuoteEvent({
    required this.id,
    required this.items,
    this.discount,
    this.tax,
    this.deliveryCharges,
    required this.validUntil,
    this.adminNotes,
  });

  @override
  List<Object?> get props => [id, items, discount, tax, deliveryCharges, validUntil, adminNotes];
}

class AcceptQuoteEvent extends QuoteEvent {
  final String id;
  const AcceptQuoteEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class RejectQuoteEvent extends QuoteEvent {
  final String id;
  final String reason;
  const RejectQuoteEvent(this.id, this.reason);

  @override
  List<Object?> get props => [id, reason];
}

class CancelQuoteEvent extends QuoteEvent {
  final String id;
  const CancelQuoteEvent(this.id);

  @override
  List<Object?> get props => [id];
}
