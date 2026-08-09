import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:factory_management/features/inventory/domain/usecases/add_stock.dart';
import 'package:factory_management/features/inventory/domain/usecases/adjust_stock.dart';
import 'package:factory_management/features/inventory/domain/usecases/get_inventory.dart';
import 'package:factory_management/features/inventory/domain/usecases/get_inventory_details.dart';
import 'package:factory_management/features/inventory/domain/usecases/get_stock_history.dart';
import 'package:factory_management/features/inventory/domain/usecases/remove_stock.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_event.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetInventory getInventory;
  final GetInventoryDetails getInventoryDetails;
  final AddStock addStock;
  final RemoveStock removeStock;
  final AdjustStock adjustStock;
  final GetStockHistory getStockHistory;

  InventoryBloc({
    required this.getInventory,
    required this.getInventoryDetails,
    required this.addStock,
    required this.removeStock,
    required this.adjustStock,
    required this.getStockHistory,
  }) : super(const InventoryState()) {
    on<LoadInventory>(_onLoadInventory);
    on<RefreshInventory>(_onRefreshInventory);
    on<SearchInventoryEvent>(_onSearchInventory);
    on<FilterInventoryByStatus>(_onFilterByStatus);
    on<FilterInventoryByCategory>(_onFilterByCategory);
    on<SortInventoryEvent>(_onSortInventory);
    on<GetInventoryDetailsEvent>(_onGetInventoryDetails);
    on<AddStockEvent>(_onAddStock);
    on<RemoveStockEvent>(_onRemoveStock);
    on<AdjustStockEvent>(_onAdjustStock);
    on<LoadStockHistory>(_onLoadStockHistory);
  }

  Future<void> _onLoadInventory(
    LoadInventory event,
    Emitter<InventoryState> emit,
  ) async {
    if (state.hasReachedMax && event.page != 1) return;

    if (event.page == 1) {
      emit(state.copyWith(status: InventoryStateStatus.loading, inventory: []));
    }

    final result = await getInventory(
      page: event.page,
      searchQuery: event.searchQuery ?? state.searchQuery,
      categoryId: event.categoryId ?? state.categoryId,
      status: event.status ?? state.filterStatus,
      sortBy: event.sortBy ?? state.sortBy,
      descending: event.descending,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: InventoryStateStatus.failure,
        errorMessage: failure.message,
      )),
      (inventory) {
        emit(state.copyWith(
          status: InventoryStateStatus.success,
          inventory: event.page == 1 ? inventory : [...state.inventory, ...inventory],
          currentPage: event.page,
          hasReachedMax: inventory.length < 10, // Assuming pageSize is 10
          searchQuery: event.searchQuery,
          categoryId: event.categoryId,
          filterStatus: event.status,
          sortBy: event.sortBy,
          descending: event.descending,
        ));
      },
    );
  }

  Future<void> _onRefreshInventory(
    RefreshInventory event,
    Emitter<InventoryState> emit,
  ) async {
    add(LoadInventory(
      page: 1,
      searchQuery: state.searchQuery,
      categoryId: state.categoryId,
      status: state.filterStatus,
      sortBy: state.sortBy,
      descending: state.descending,
    ));
  }

  Future<void> _onSearchInventory(
    SearchInventoryEvent event,
    Emitter<InventoryState> emit,
  ) async {
    add(LoadInventory(page: 1, searchQuery: event.query));
  }

  Future<void> _onFilterByStatus(
    FilterInventoryByStatus event,
    Emitter<InventoryState> emit,
  ) async {
    add(LoadInventory(page: 1, status: event.status));
  }

  Future<void> _onFilterByCategory(
    FilterInventoryByCategory event,
    Emitter<InventoryState> emit,
  ) async {
    add(LoadInventory(page: 1, categoryId: event.categoryId));
  }

  Future<void> _onSortInventory(
    SortInventoryEvent event,
    Emitter<InventoryState> emit,
  ) async {
    add(LoadInventory(page: 1, sortBy: event.sortBy, descending: event.descending));
  }

  Future<void> _onGetInventoryDetails(
    GetInventoryDetailsEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(status: InventoryStateStatus.loading));
    final result = await getInventoryDetails(event.productId);
    
    // Also load recent history for this product
    final historyResult = await getStockHistory(
      page: 1,
      productId: event.productId,
    );

    result.fold(
      (failure) => emit(state.copyWith(status: InventoryStateStatus.failure, errorMessage: failure.message)),
      (inventory) {
        historyResult.fold(
          (hFailure) => emit(state.copyWith(
            status: InventoryStateStatus.success, 
            selectedInventory: inventory,
            history: [],
          )),
          (history) => emit(state.copyWith(
            status: InventoryStateStatus.success, 
            selectedInventory: inventory,
            history: history,
          )),
        );
      },
    );
  }

  Future<void> _onAddStock(
    AddStockEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(status: InventoryStateStatus.submitting));
    final result = await addStock(
      productId: event.productId,
      quantity: event.quantity,
      reason: event.reason,
      reference: event.reference,
      notes: event.notes,
    );
    result.fold(
      (failure) => emit(state.copyWith(status: InventoryStateStatus.failure, errorMessage: failure.message)),
      (inventory) {
        emit(state.copyWith(status: InventoryStateStatus.success, selectedInventory: inventory));
        add(RefreshInventory());
      },
    );
  }

  Future<void> _onRemoveStock(
    RemoveStockEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(status: InventoryStateStatus.submitting));
    final result = await removeStock(
      productId: event.productId,
      quantity: event.quantity,
      reason: event.reason,
      reference: event.reference,
      notes: event.notes,
    );
    result.fold(
      (failure) => emit(state.copyWith(status: InventoryStateStatus.failure, errorMessage: failure.message)),
      (inventory) {
        emit(state.copyWith(status: InventoryStateStatus.success, selectedInventory: inventory));
        add(RefreshInventory());
      },
    );
  }

  Future<void> _onAdjustStock(
    AdjustStockEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(status: InventoryStateStatus.submitting));
    final result = await adjustStock(
      productId: event.productId,
      newQuantity: event.newQuantity,
      reason: event.reason,
      notes: event.notes,
    );
    result.fold(
      (failure) => emit(state.copyWith(status: InventoryStateStatus.failure, errorMessage: failure.message)),
      (inventory) {
        emit(state.copyWith(status: InventoryStateStatus.success, selectedInventory: inventory));
        add(RefreshInventory());
      },
    );
  }

  Future<void> _onLoadStockHistory(
    LoadStockHistory event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(status: InventoryStateStatus.loading));
    final result = await getStockHistory(
      page: event.page,
      productId: event.productId,
      type: event.type,
    );
    result.fold(
      (failure) => emit(state.copyWith(status: InventoryStateStatus.failure, errorMessage: failure.message)),
      (history) => emit(state.copyWith(status: InventoryStateStatus.success, history: history)),
    );
  }
}
