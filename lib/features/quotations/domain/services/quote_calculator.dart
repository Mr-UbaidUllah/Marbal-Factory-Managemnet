import '../entities/quote_item.dart';

class QuoteTotals {
  final double subtotal;
  final double discount;
  final double tax;
  final double deliveryCharges;
  final double total;

  QuoteTotals({
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.deliveryCharges,
    required this.total,
  });
}

class QuoteCalculator {
  static QuoteTotals calculate({
    required List<QuoteItem> items,
    double discount = 0.0,
    double taxRate = 0.0, // e.g., 0.15 for 15%
    double deliveryCharges = 0.0,
  }) {
    double itemsSubtotal = 0;
    double itemsDiscount = 0;

    for (var item in items) {
      itemsSubtotal += item.quantity * item.quotedPrice;
      itemsDiscount += item.discount;
    }

    double subtotal = itemsSubtotal - itemsDiscount;
    double calculatedTax = subtotal * taxRate;
    double total = subtotal - discount + calculatedTax + deliveryCharges;

    return QuoteTotals(
      subtotal: itemsSubtotal,
      discount: itemsDiscount + discount,
      tax: calculatedTax,
      deliveryCharges: deliveryCharges,
      total: total,
    );
  }
}
