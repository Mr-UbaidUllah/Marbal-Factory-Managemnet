enum PaymentMethod {
  cash,
  bankTransfer,
  card,
  other,
}

extension PaymentMethodX on PaymentMethod {
  String get name {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.other:
        return 'Other';
    }
  }
}
