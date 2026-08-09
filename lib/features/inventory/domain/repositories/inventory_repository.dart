import 'package:dartz/dartz.dart';
import 'package:factory_management/features/inventory/domain/entities/inventory.dart';
import 'package:factory_management/features/inventory/domain/entities/stock_transaction.dart';

import '../../../../core/errors/failures.dart';

abstract class InventoryRepository {
  Future<Either<Failure, List<Inventory>>> getInventory({
    int page = 1,
    int pageSize = 10,
    String? searchQuery,
    String? categoryId,
    InventoryStatus? status,
    String? sortBy,
    bool descending = true,
  });

  Future<Either<Failure, Inventory>> getInventoryByProductId(String productId);

  Future<Either<Failure, Inventory>> addStock({
    required String productId,
    required int quantity,
    required String reason,
    String? reference,
    String? notes,
  });

  Future<Either<Failure, Inventory>> removeStock({
    required String productId,
    required int quantity,
    required String reason,
    String? reference,
    String? notes,
  });

  Future<Either<Failure, Inventory>> adjustStock({
    required String productId,
    required int newQuantity,
    required String reason,
    String? notes,
  });

  Future<Either<Failure, List<StockTransaction>>> getStockHistory({
    int page = 1,
    int pageSize = 10,
    String? productId,
    StockTransactionType? type,
    DateTime? startDate,
    DateTime? endDate,
  });
}
