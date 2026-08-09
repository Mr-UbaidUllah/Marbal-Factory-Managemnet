import 'package:equatable/equatable.dart';
import 'package:factory_management/features/inventory/domain/entities/inventory.dart' as entity;
import 'package:factory_management/features/inventory/domain/entities/stock_transaction.dart';

enum InventoryStateStatus { initial, loading, success, failure, submitting }

class InventoryState extends Equatable {
  final List<entity.Inventory> inventory;
  final List<StockTransaction> history;
  final entity.Inventory? selectedInventory;
  final InventoryStateStatus status;
  final String? errorMessage;
  
  // Filters & Pagination
  final int currentPage;
  final String? searchQuery;
  final String? categoryId;
  final entity.InventoryStatus? filterStatus;
  final String sortBy;
  final bool descending;
  final bool hasReachedMax;

  const InventoryState({
    this.inventory = const [],
    this.history = const [],
    this.selectedInventory,
    this.status = InventoryStateStatus.initial,
    this.errorMessage,
    this.currentPage = 1,
    this.searchQuery,
    this.categoryId,
    this.filterStatus,
    this.sortBy = 'updatedAt',
    this.descending = true,
    this.hasReachedMax = false,
  });

  InventoryState copyWith({
    List<entity.Inventory>? inventory,
    List<StockTransaction>? history,
    entity.Inventory? selectedInventory,
    InventoryStateStatus? status,
    String? errorMessage,
    int? currentPage,
    String? searchQuery,
    String? categoryId,
    entity.InventoryStatus? filterStatus,
    String? sortBy,
    bool? descending,
    bool? hasReachedMax,
  }) {
    return InventoryState(
      inventory: inventory ?? this.inventory,
      history: history ?? this.history,
      selectedInventory: selectedInventory ?? this.selectedInventory,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: categoryId ?? this.categoryId,
      filterStatus: filterStatus ?? this.filterStatus,
      sortBy: sortBy ?? this.sortBy,
      descending: descending ?? this.descending,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        inventory,
        history,
        selectedInventory,
        status,
        errorMessage,
        currentPage,
        searchQuery,
        categoryId,
        filterStatus,
        sortBy,
        descending,
        hasReachedMax,
      ];
}
