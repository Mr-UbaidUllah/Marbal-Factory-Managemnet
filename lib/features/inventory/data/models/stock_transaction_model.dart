import 'package:factory_management/features/inventory/domain/entities/stock_transaction.dart';

class StockTransactionModel extends StockTransaction {
  const StockTransactionModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.type,
    required super.quantity,
    required super.previousQuantity,
    required super.newQuantity,
    required super.reason,
    super.reference,
    required super.performedBy,
    required super.createdAt,
    super.notes,
  });

  factory StockTransactionModel.fromJson(Map<String, dynamic> json) {
    return StockTransactionModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      type: StockTransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => StockTransactionType.adjustment,
      ),
      quantity: json['quantity'] as int,
      previousQuantity: json['previousQuantity'] as int,
      newQuantity: json['newQuantity'] as int,
      reason: json['reason'] as String,
      reference: json['reference'] as String?,
      performedBy: json['performedBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'type': type.name,
      'quantity': quantity,
      'previousQuantity': previousQuantity,
      'newQuantity': newQuantity,
      'reason': reason,
      'reference': reference,
      'performedBy': performedBy,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
    };
  }
}
