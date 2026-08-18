class FinancialCalculator {
  static double calculateSubtotal(List<dynamic> items) {
    return items.fold(0.0, (sum, item) => sum + (item.quantity * item.unitPrice));
  }

  static double calculateTotal({
    required double subtotal,
    required double discount,
    required double tax,
    required double deliveryCharges,
  }) {
    return subtotal - discount + tax + deliveryCharges;
  }
}
