import 'package:dartz/dartz.dart';

import 'package:factory_management/features/inventory/domain/entities/inventory.dart';
import 'package:factory_management/features/inventory/domain/repositories/inventory_repository.dart';

import '../../../../core/errors/failures.dart';

class AdjustStock {
  final InventoryRepository repository;

  AdjustStock(this.repository);

  Future<Either<Failure, Inventory>> call({
    required String productId,
    required int newQuantity,
    required String reason,
    String? notes,
  }) {
    return repository.adjustStock(
      productId: productId,
      newQuantity: newQuantity,
      reason: reason,
      notes: notes,
    );
  }
}
