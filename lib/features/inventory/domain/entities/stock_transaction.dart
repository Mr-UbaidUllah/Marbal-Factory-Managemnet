import 'package:equatable/equatable.dart';

enum StockTransactionType {
  stockIn,
  stockOut,
  adjustment,
  transfer,
  returned,
}

class StockTransaction extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final StockTransactionType type;
  final int quantity;
  final int previousQuantity;
  final int newQuantity;
  final String reason;
  final String? reference;
  final String performedBy;
  final DateTime createdAt;
  final String? notes;

  const StockTransaction({
    required this.id,
    required this.productId,
    required this.productName,
    required this.type,
    required this.quantity,
    required this.previousQuantity,
    required this.newQuantity,
    required this.reason,
    this.reference,
    required this.performedBy,
    required this.createdAt,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        productName,
        type,
        quantity,
        previousQuantity,
        newQuantity,
        reason,
        reference,
        performedBy,
        createdAt,
        notes,
      ];
}
