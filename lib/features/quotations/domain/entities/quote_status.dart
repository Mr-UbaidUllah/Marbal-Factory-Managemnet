enum QuoteStatus {
  draft,
  pending,
  underReview,
  quoted,
  accepted,
  rejected,
  expired,
  cancelled,
}

extension QuoteStatusX on QuoteStatus {
  String get name {
    switch (this) {
      case QuoteStatus.draft:
        return 'Draft';
      case QuoteStatus.pending:
        return 'Pending';
      case QuoteStatus.underReview:
        return 'Under Review';
      case QuoteStatus.quoted:
        return 'Quoted';
      case QuoteStatus.accepted:
        return 'Accepted';
      case QuoteStatus.rejected:
        return 'Rejected';
      case QuoteStatus.expired:
        return 'Expired';
      case QuoteStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool canTransitionTo(QuoteStatus nextStatus) {
    switch (this) {
      case QuoteStatus.draft:
        return [QuoteStatus.pending, QuoteStatus.cancelled].contains(nextStatus);
      case QuoteStatus.pending:
        return [QuoteStatus.underReview, QuoteStatus.cancelled].contains(nextStatus);
      case QuoteStatus.underReview:
        return [QuoteStatus.quoted, QuoteStatus.cancelled].contains(nextStatus);
      case QuoteStatus.quoted:
        return [QuoteStatus.accepted, QuoteStatus.rejected, QuoteStatus.expired, QuoteStatus.cancelled].contains(nextStatus);
      case QuoteStatus.accepted:
      case QuoteStatus.rejected:
      case QuoteStatus.expired:
      case QuoteStatus.cancelled:
        return false;
    }
  }
}
