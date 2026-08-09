import 'package:dartz/dartz.dart';
import 'package:factory_management/features/inventory/domain/entities/stock_transaction.dart';
import 'package:factory_management/features/inventory/domain/repositories/inventory_repository.dart';

import '../../../../core/errors/failures.dart';

class GetStockHistory {
  final InventoryRepository repository;

  GetStockHistory(this.repository);

  Future<Either<Failure, List<StockTransaction>>> call({
    int page = 1,
    int pageSize = 10,
    String? productId,
    StockTransactionType? type,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return repository.getStockHistory(
      page: page,
      pageSize: pageSize,
      productId: productId,
      type: type,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
