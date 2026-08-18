import 'package:equatable/equatable.dart';
import 'quote_status.dart';

class QuoteStatusHistory extends Equatable {
  final String id;
  final String quoteId;
  final QuoteStatus previousStatus;
  final QuoteStatus newStatus;
  final String? note;
  final String changedBy;
  final DateTime createdAt;

  const QuoteStatusHistory({
    required this.id,
    required this.quoteId,
    required this.previousStatus,
    required this.newStatus,
    this.note,
    required this.changedBy,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        quoteId,
        previousStatus,
        newStatus,
        note,
        changedBy,
        createdAt,
      ];
}
