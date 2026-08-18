import '../../domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.id,
    required super.orderId,
    required super.productId,
    required super.productName,
    required super.sku,
    required super.categoryId,
    required super.categoryName,
    required super.quantity,
    required super.unit,
    required super.unitPrice,
    super.discount,
    super.notes,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      sku: json['sku'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'productName': productName,
      'sku': sku,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'quantity': quantity,
      'unit': unit,
      'unitPrice': unitPrice,
      'discount': discount,
      'notes': notes,
    };
  }

  factory OrderItemModel.fromEntity(OrderItem entity) {
    return OrderItemModel(
      id: entity.id,
      orderId: entity.orderId,
      productId: entity.productId,
      productName: entity.productName,
      sku: entity.sku,
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      quantity: entity.quantity,
      unit: entity.unit,
      unitPrice: entity.unitPrice,
      discount: entity.discount,
      notes: entity.notes,
    );
  }
}
