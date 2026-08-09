import 'package:dartz/dartz.dart';
import 'package:factory_management/features/inventory/domain/entities/inventory.dart';
import 'package:factory_management/features/inventory/domain/repositories/inventory_repository.dart';

import '../../../../core/errors/failures.dart';

class AddStock {
  final InventoryRepository repository;

  AddStock(this.repository);

  Future<Either<Failure, Inventory>> call({
    required String productId,
    required int quantity,
    required String reason,
    String? reference,
    String? notes,
  }) {
    return repository.addStock(
      productId: productId,
      quantity: quantity,
      reason: reason,
      reference: reference,
      notes: notes,
    );
  }
}
