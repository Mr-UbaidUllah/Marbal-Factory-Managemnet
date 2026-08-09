import 'package:factory_management/features/inventory/domain/entities/inventory.dart';

class InventoryModel extends Inventory {
  const InventoryModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.sku,
    required super.categoryId,
    required super.categoryName,
    required super.quantity,
    required super.reservedQuantity,
    required super.minimumStock,
    required super.maximumStock,
    required super.unit,
    super.locationId,
    required super.lastStockUpdate,
    required super.createdAt,
    required super.updatedAt,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      sku: json['sku'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      quantity: json['quantity'] as int,
      reservedQuantity: json['reservedQuantity'] as int,
      minimumStock: json['minimumStock'] as int,
      maximumStock: json['maximumStock'] as int,
      unit: json['unit'] as String,
      locationId: json['locationId'] as String?,
      lastStockUpdate: DateTime.parse(json['lastStockUpdate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'sku': sku,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'quantity': quantity,
      'reservedQuantity': reservedQuantity,
      'minimumStock': minimumStock,
      'maximumStock': maximumStock,
      'unit': unit,
      'locationId': locationId,
      'lastStockUpdate': lastStockUpdate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory InventoryModel.fromEntity(Inventory inventory) {
    return InventoryModel(
      id: inventory.id,
      productId: inventory.productId,
      productName: inventory.productName,
      sku: inventory.sku,
      categoryId: inventory.categoryId,
      categoryName: inventory.categoryName,
      quantity: inventory.quantity,
      reservedQuantity: inventory.reservedQuantity,
      minimumStock: inventory.minimumStock,
      maximumStock: inventory.maximumStock,
      unit: inventory.unit,
      locationId: inventory.locationId,
      lastStockUpdate: inventory.lastStockUpdate,
      createdAt: inventory.createdAt,
      updatedAt: inventory.updatedAt,
    );
  }
}
