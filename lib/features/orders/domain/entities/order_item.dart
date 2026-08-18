import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final String sku;
  final String categoryId;
  final String categoryName;
  final double quantity;
  final String unit;
  final double unitPrice;
  final double discount;
  final String? notes;

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.sku,
    required this.categoryId,
    required this.categoryName,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    this.discount = 0.0,
    this.notes,
  });

  double get subtotal => (quantity * unitPrice) - discount;

  @override
  List<Object?> get props => [
        id,
        orderId,
        productId,
        productName,
        sku,
        categoryId,
        categoryName,
        quantity,
        unit,
        unitPrice,
        discount,
        notes,
      ];

  OrderItem copyWith({
    String? id,
    String? orderId,
    String? productId,
    String? productName,
    String? sku,
    String? categoryId,
    String? categoryName,
    double? quantity,
    String? unit,
    double? unitPrice,
    double? discount,
    String? notes,
  }) {
    return OrderItem(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      sku: sku ?? this.sku,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      discount: discount ?? this.discount,
      notes: notes ?? this.notes,
    );
  }
}
