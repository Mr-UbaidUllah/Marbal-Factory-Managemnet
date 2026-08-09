import 'package:equatable/equatable.dart';

enum InventoryStatus {
  inStock,
  lowStock,
  outOfStock,
  overstocked, loading,
}

class Inventory extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final String sku;
  final String categoryId;
  final String categoryName;
  final int quantity;
  final int reservedQuantity;
  final int minimumStock;
  final int maximumStock;
  final String unit;
  final String? locationId;
  final DateTime lastStockUpdate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Inventory({
    required this.id,
    required this.productId,
    required this.productName,
    required this.sku,
    required this.categoryId,
    required this.categoryName,
    required this.quantity,
    required this.reservedQuantity,
    required this.minimumStock,
    required this.maximumStock,
    required this.unit,
    this.locationId,
    required this.lastStockUpdate,
    required this.createdAt,
    required this.updatedAt,
  });

  int get availableQuantity => quantity - reservedQuantity;

  InventoryStatus get status {
    if (quantity <= 0) return InventoryStatus.outOfStock;
    if (quantity <= minimumStock) return InventoryStatus.lowStock;
    if (quantity >= maximumStock && maximumStock > 0) return InventoryStatus.overstocked;
    return InventoryStatus.inStock;
  }

  @override
  List<Object?> get props => [
        id,
        productId,
        productName,
        sku,
        categoryId,
        categoryName,
        quantity,
        reservedQuantity,
        minimumStock,
        maximumStock,
        unit,
        locationId,
        lastStockUpdate,
        createdAt,
        updatedAt,
      ];

  Inventory copyWith({
    String? id,
    String? productId,
    String? productName,
    String? sku,
    String? categoryId,
    String? categoryName,
    int? quantity,
    int? reservedQuantity,
    int? minimumStock,
    int? maximumStock,
    String? unit,
    String? locationId,
    DateTime? lastStockUpdate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Inventory(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      sku: sku ?? this.sku,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      quantity: quantity ?? this.quantity,
      reservedQuantity: reservedQuantity ?? this.reservedQuantity,
      minimumStock: minimumStock ?? this.minimumStock,
      maximumStock: maximumStock ?? this.maximumStock,
      unit: unit ?? this.unit,
      locationId: locationId ?? this.locationId,
      lastStockUpdate: lastStockUpdate ?? this.lastStockUpdate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
