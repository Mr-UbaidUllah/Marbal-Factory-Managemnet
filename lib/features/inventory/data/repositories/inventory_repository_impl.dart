import 'package:dartz/dartz.dart';
import 'package:factory_management/features/inventory/data/models/inventory_model.dart';
import 'package:factory_management/features/inventory/data/models/stock_transaction_model.dart';
import 'package:factory_management/features/inventory/domain/entities/inventory.dart';
import 'package:factory_management/features/inventory/domain/entities/stock_transaction.dart';
import 'package:factory_management/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  // Mock data for initial implementation
  final List<InventoryModel> _mockInventory = [
    InventoryModel(
      id: '1',
      productId: 'p1',
      productName: 'Italian Carrara Marble',
      sku: 'MAR-ITA-001',
      categoryId: 'cat1',
      categoryName: 'Marble',
      quantity: 150,
      reservedQuantity: 20,
      minimumStock: 50,
      maximumStock: 500,
      unit: 'sqm',
      locationId: 'WH-A1',
      lastStockUpdate: DateTime.now().subtract(const Duration(days: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    InventoryModel(
      id: '2',
      productId: 'p2',
      productName: 'Black Galaxy Granite',
      sku: 'GRA-IND-002',
      categoryId: 'cat2',
      categoryName: 'Granite',
      quantity: 8,
      reservedQuantity: 0,
      minimumStock: 20,
      maximumStock: 200,
      unit: 'sqm',
      locationId: 'WH-B2',
      lastStockUpdate: DateTime.now().subtract(const Duration(hours: 5)),
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    InventoryModel(
      id: '3',
      productId: 'p3',
      productName: 'Absolute Black Granite',
      sku: 'GRA-IND-003',
      categoryId: 'cat2',
      categoryName: 'Granite',
      quantity: 0,
      reservedQuantity: 0,
      minimumStock: 15,
      maximumStock: 150,
      unit: 'sqm',
      locationId: 'WH-B1',
      lastStockUpdate: DateTime.now().subtract(const Duration(days: 10)),
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    InventoryModel(
      id: '4',
      productId: 'p4',
      productName: 'White Onyx',
      sku: 'ONX-TUR-004',
      categoryId: 'cat3',
      categoryName: 'Onyx',
      quantity: 45,
      reservedQuantity: 5,
      minimumStock: 10,
      maximumStock: 100,
      unit: 'pieces',
      locationId: 'WH-C1',
      lastStockUpdate: DateTime.now().subtract(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  final List<StockTransactionModel> _mockTransactions = [];

  @override
  Future<Either<Failure, List<Inventory>>> getInventory({
    int page = 1,
    int pageSize = 10,
    String? searchQuery,
    String? categoryId,
    InventoryStatus? status,
    String? sortBy,
    bool descending = true,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      List<InventoryModel> results = List.from(_mockInventory);

      if (searchQuery != null && searchQuery.isNotEmpty) {
        results = results.where((item) => 
          item.productName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.sku.toLowerCase().contains(searchQuery.toLowerCase())
        ).toList();
      }

      if (categoryId != null && categoryId.isNotEmpty) {
        results = results.where((item) => item.categoryId == categoryId).toList();
      }

      if (status != null) {
        results = results.where((item) => item.status == status).toList();
      }

      // Sort
      if (sortBy != null) {
        results.sort((a, b) {
          int cmp;
          switch (sortBy) {
            case 'productName':
              cmp = a.productName.compareTo(b.productName);
              break;
            case 'quantity':
              cmp = a.quantity.compareTo(b.quantity);
              break;
            case 'availableQuantity':
              cmp = a.availableQuantity.compareTo(b.availableQuantity);
              break;
            case 'updatedAt':
              cmp = a.updatedAt.compareTo(b.updatedAt);
              break;
            default:
              cmp = 0;
          }
          return descending ? -cmp : cmp;
        });
      }

      // Pagination
      final startIndex = (page - 1) * pageSize;
      if (startIndex >= results.length) return const Right([]);
      
      final endIndex = startIndex + pageSize;
      final paginatedResults = results.sublist(
        startIndex, 
        endIndex > results.length ? results.length : endIndex
      );

      return Right(paginatedResults);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Inventory>> getInventoryByProductId(String productId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final item = _mockInventory.firstWhere(
        (element) => element.productId == productId,
        orElse: () => throw Exception('Inventory record not found'),
      );
      return Right(item);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Inventory>> addStock({
    required String productId,
    required int quantity,
    required String reason,
    String? reference,
    String? notes,
  }) async {
    try {
      final index = _mockInventory.indexWhere((item) => item.productId == productId);
      if (index == -1) return const Left(ServerFailure('Product not found in inventory'));

      final current = _mockInventory[index];
      final newQuantity = current.quantity + quantity;
      
      final updated = current.copyWith(
        quantity: newQuantity,
        lastStockUpdate: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _mockInventory[index] = InventoryModel.fromEntity(updated);

      final transaction = StockTransactionModel(
        id: const Uuid().v4(),
        productId: productId,
        productName: current.productName,
        type: StockTransactionType.stockIn,
        quantity: quantity,
        previousQuantity: current.quantity,
        newQuantity: newQuantity,
        reason: reason,
        reference: reference,
        performedBy: 'Admin', // In real app, get from Auth
        createdAt: DateTime.now(),
        notes: notes,
      );
      _mockTransactions.insert(0, transaction);

      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Inventory>> removeStock({
    required String productId,
    required int quantity,
    required String reason,
    String? reference,
    String? notes,
  }) async {
    try {
      final index = _mockInventory.indexWhere((item) => item.productId == productId);
      if (index == -1) return const Left(ServerFailure('Product not found in inventory'));

      final current = _mockInventory[index];
      if (current.availableQuantity < quantity) {
        return const Left(ValidationFailure('Insufficient stock available'));
      }

      final newQuantity = current.quantity - quantity;
      
      final updated = current.copyWith(
        quantity: newQuantity,
        lastStockUpdate: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _mockInventory[index] = InventoryModel.fromEntity(updated);

      final transaction = StockTransactionModel(
        id: const Uuid().v4(),
        productId: productId,
        productName: current.productName,
        type: StockTransactionType.stockOut,
        quantity: quantity,
        previousQuantity: current.quantity,
        newQuantity: newQuantity,
        reason: reason,
        reference: reference,
        performedBy: 'Admin',
        createdAt: DateTime.now(),
        notes: notes,
      );
      _mockTransactions.insert(0, transaction);

      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Inventory>> adjustStock({
    required String productId,
    required int newQuantity,
    required String reason,
    String? notes,
  }) async {
    try {
      if (newQuantity < 0) return const Left(ValidationFailure('Quantity cannot be negative'));

      final index = _mockInventory.indexWhere((item) => item.productId == productId);
      if (index == -1) return const Left(ServerFailure('Product not found in inventory'));

      final current = _mockInventory[index];
      final difference = newQuantity - current.quantity;
      
      final updated = current.copyWith(
        quantity: newQuantity,
        lastStockUpdate: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _mockInventory[index] = InventoryModel.fromEntity(updated);

      final transaction = StockTransactionModel(
        id: const Uuid().v4(),
        productId: productId,
        productName: current.productName,
        type: StockTransactionType.adjustment,
        quantity: difference.abs(),
        previousQuantity: current.quantity,
        newQuantity: newQuantity,
        reason: reason,
        performedBy: 'Admin',
        createdAt: DateTime.now(),
        notes: notes,
      );
      _mockTransactions.insert(0, transaction);

      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StockTransaction>>> getStockHistory({
    int page = 1,
    int pageSize = 10,
    String? productId,
    StockTransactionType? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      List<StockTransactionModel> results = List.from(_mockTransactions);

      if (productId != null) {
        results = results.where((t) => t.productId == productId).toList();
      }

      if (type != null) {
        results = results.where((t) => t.type == type).toList();
      }

      if (startDate != null) {
        results = results.where((t) => t.createdAt.isAfter(startDate)).toList();
      }

      if (endDate != null) {
        results = results.where((t) => t.createdAt.isBefore(endDate)).toList();
      }

      final startIndex = (page - 1) * pageSize;
      if (startIndex >= results.length) return const Right([]);
      
      final endIndex = startIndex + pageSize;
      return Right(results.sublist(
        startIndex, 
        endIndex > results.length ? results.length : endIndex
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
