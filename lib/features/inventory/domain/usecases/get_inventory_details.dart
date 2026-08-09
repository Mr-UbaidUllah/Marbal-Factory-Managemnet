import 'package:dartz/dartz.dart';
import 'package:factory_management/features/inventory/domain/entities/inventory.dart';
import 'package:factory_management/features/inventory/domain/repositories/inventory_repository.dart';

import '../../../../core/errors/failures.dart';

class GetInventoryDetails {
  final InventoryRepository repository;

  GetInventoryDetails(this.repository);

  Future<Either<Failure, Inventory>> call(String productId) {
    return repository.getInventoryByProductId(productId);
  }
}
