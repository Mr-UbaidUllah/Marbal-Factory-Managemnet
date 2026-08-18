enum PaymentStatus {
  pending,
  partial,
  paid,
  refunded,
}

extension PaymentStatusX on PaymentStatus {
  String get name {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.partial:
        return 'Partial';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }
}
