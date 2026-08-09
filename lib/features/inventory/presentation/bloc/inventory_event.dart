import 'package:equatable/equatable.dart';
import 'package:factory_management/features/inventory/domain/entities/inventory.dart';
import 'package:factory_management/features/inventory/domain/entities/stock_transaction.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadInventory extends InventoryEvent {
  final int page;
  final String? searchQuery;
  final String? categoryId;
  final InventoryStatus? status;
  final String? sortBy;
  final bool descending;

  const LoadInventory({
    this.page = 1,
    this.searchQuery,
    this.categoryId,
    this.status,
    this.sortBy,
    this.descending = true,
  });

  @override
  List<Object?> get props => [page, searchQuery, categoryId, status, sortBy, descending];
}

class RefreshInventory extends InventoryEvent {}

class SearchInventoryEvent extends InventoryEvent {
  final String query;
  const SearchInventoryEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterInventoryByStatus extends InventoryEvent {
  final InventoryStatus? status;
  const FilterInventoryByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class FilterInventoryByCategory extends InventoryEvent {
  final String? categoryId;
  const FilterInventoryByCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class SortInventoryEvent extends InventoryEvent {
  final String sortBy;
  final bool descending;
  const SortInventoryEvent(this.sortBy, this.descending);

  @override
  List<Object?> get props => [sortBy, descending];
}

class GetInventoryDetailsEvent extends InventoryEvent {
  final String productId;
  const GetInventoryDetailsEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class AddStockEvent extends InventoryEvent {
  final String productId;
  final int quantity;
  final String reason;
  final String? reference;
  final String? notes;

  const AddStockEvent({
    required this.productId,
    required this.quantity,
    required this.reason,
    this.reference,
    this.notes,
  });

  @override
  List<Object?> get props => [productId, quantity, reason, reference, notes];
}

class RemoveStockEvent extends InventoryEvent {
  final String productId;
  final int quantity;
  final String reason;
  final String? reference;
  final String? notes;

  const RemoveStockEvent({
    required this.productId,
    required this.quantity,
    required this.reason,
    this.reference,
    this.notes,
  });

  @override
  List<Object?> get props => [productId, quantity, reason, reference, notes];
}

class AdjustStockEvent extends InventoryEvent {
  final String productId;
  final int newQuantity;
  final String reason;
  final String? notes;

  const AdjustStockEvent({
    required this.productId,
    required this.newQuantity,
    required this.reason,
    this.notes,
  });

  @override
  List<Object?> get props => [productId, newQuantity, reason, notes];
}

class LoadStockHistory extends InventoryEvent {
  final int page;
  final String? productId;
  final StockTransactionType? type;

  const LoadStockHistory({
    this.page = 1,
    this.productId,
    this.type,
  });

  @override
  List<Object?> get props => [page, productId, type];
}
