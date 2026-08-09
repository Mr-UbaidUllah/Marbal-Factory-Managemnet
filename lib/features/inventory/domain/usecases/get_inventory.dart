import 'package:dartz/dartz.dart';
import 'package:factory_management/features/inventory/domain/entities/inventory.dart';
import 'package:factory_management/features/inventory/domain/repositories/inventory_repository.dart';

import '../../../../core/errors/failures.dart';

class GetInventory {
  final InventoryRepository repository;

  GetInventory(this.repository);

  Future<Either<Failure, List<Inventory>>> call({
    int page = 1,
    int pageSize = 10,
    String? searchQuery,
    String? categoryId,
    InventoryStatus? status,
    String? sortBy,
    bool descending = true,
  }) {
    return repository.getInventory(
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      categoryId: categoryId,
      status: status,
      sortBy: sortBy,
      descending: descending,
    );
  }
}
