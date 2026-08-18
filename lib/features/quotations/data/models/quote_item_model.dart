import '../../domain/entities/quote_item.dart';

class QuoteItemModel extends QuoteItem {
  const QuoteItemModel({
    required super.id,
    required super.quoteId,
    required super.productId,
    required super.productName,
    required super.sku,
    required super.categoryId,
    required super.categoryName,
    required super.quantity,
    required super.unit,
    super.requestedPrice,
    required super.quotedPrice,
    super.discount = 0.0,
    super.notes,
  });

  factory QuoteItemModel.fromJson(Map<String, dynamic> json) {
    return QuoteItemModel(
      id: json['id'] as String,
      quoteId: json['quoteId'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      sku: json['sku'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      requestedPrice: json['requestedPrice'] != null ? (json['requestedPrice'] as num).toDouble() : null,
      quotedPrice: (json['quotedPrice'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quoteId': quoteId,
      'productId': productId,
      'productName': productName,
      'sku': sku,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'quantity': quantity,
      'unit': unit,
      'requestedPrice': requestedPrice,
      'quotedPrice': quotedPrice,
      'discount': discount,
      'notes': notes,
    };
  }

  factory QuoteItemModel.fromEntity(QuoteItem item) {
    return QuoteItemModel(
      id: item.id,
      quoteId: item.quoteId,
      productId: item.productId,
      productName: item.productName,
      sku: item.sku,
      categoryId: item.categoryId,
      categoryName: item.categoryName,
      quantity: item.quantity,
      unit: item.unit,
      requestedPrice: item.requestedPrice,
      quotedPrice: item.quotedPrice,
      discount: item.discount,
      notes: item.notes,
    );
  }
}
