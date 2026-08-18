import 'package:equatable/equatable.dart';

class QuoteItem extends Equatable {
  final String id;
  final String quoteId;
  final String productId;
  final String productName;
  final String sku;
  final String categoryId;
  final String categoryName;
  final double quantity;
  final String unit;
  final double? requestedPrice;
  final double quotedPrice;
  final double discount;
  final String? notes;

  const QuoteItem({
    required this.id,
    required this.quoteId,
    required this.productId,
    required this.productName,
    required this.sku,
    required this.categoryId,
    required this.categoryName,
    required this.quantity,
    required this.unit,
    this.requestedPrice,
    required this.quotedPrice,
    this.discount = 0.0,
    this.notes,
  });

  double get subtotal => (quantity * quotedPrice) - discount;

  @override
  List<Object?> get props => [
        id,
        quoteId,
        productId,
        productName,
        sku,
        categoryId,
        categoryName,
        quantity,
        unit,
        requestedPrice,
        quotedPrice,
        discount,
        notes,
      ];

  QuoteItem copyWith({
    String? id,
    String? quoteId,
    String? productId,
    String? productName,
    String? sku,
    String? categoryId,
    String? categoryName,
    double? quantity,
    String? unit,
    double? requestedPrice,
    double? quotedPrice,
    double? discount,
    String? notes,
  }) {
    return QuoteItem(
      id: id ?? this.id,
      quoteId: quoteId ?? this.quoteId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      sku: sku ?? this.sku,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      requestedPrice: requestedPrice ?? this.requestedPrice,
      quotedPrice: quotedPrice ?? this.quotedPrice,
      discount: discount ?? this.discount,
      notes: notes ?? this.notes,
    );
  }
}
