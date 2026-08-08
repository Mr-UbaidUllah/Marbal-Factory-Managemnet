import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:factory_management/features/products/domain/usecases/get_products.dart';
import 'package:factory_management/features/products/domain/usecases/get_product.dart';
import 'package:factory_management/features/products/domain/usecases/create_product.dart';
import 'package:factory_management/features/products/domain/usecases/update_product.dart';
import 'package:factory_management/features/products/domain/usecases/delete_product.dart';
import 'package:factory_management/features/products/domain/repositories/product_repository.dart';
import 'package:factory_management/features/products/presentation/bloc/product_event.dart';
import 'package:factory_management/features/products/presentation/bloc/product_state.dart';


class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final GetProduct getProduct;
  final CreateProduct createProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;
  final ProductRepository repository; // Added repository directly for bulk ops for simplicity in mock

  ProductBloc({
    required this.getProducts,
    required this.getProduct,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.repository,
  }) : super(const ProductState()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<SearchProductsEvent>(
      _onSearchProducts,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 500))
          .switchMap(mapper),
    );
    on<ApplyFiltersEvent>(_onApplyFilters);
    on<ChangePageEvent>(_onChangePage);
    on<ChangeSortEvent>(_onChangeSort);
    on<GetProductEvent>(_onGetProduct);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<ToggleProductSelectionEvent>(_onToggleSelection);
    on<SelectAllProductsEvent>(_onSelectAll);
    on<ClearSelectionEvent>(_onClearSelection);
    on<BulkDeleteProductsEvent>(_onBulkDelete);
    on<BulkUpdateStatusEvent>(_onBulkUpdateStatus);
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.loading));
    
    final result = await getProducts(
      query: state.query,
      categoryId: state.categoryId,
      materialType: state.materialType,
      finish: state.finish,
      color: state.color,
      originCountry: state.originCountry,
      featured: state.featured,
      active: state.active,
      sortBy: state.sortBy,
      descending: state.descending,
      page: state.currentPage,
      limit: state.pageSize,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProductStatus.failure,
        errorMessage: 'Failed to load products',
      )),
      (paginated) => emit(state.copyWith(
        status: ProductStatus.success,
        products: paginated.products,
        totalProducts: paginated.total,
      )),
    );
  }

  Future<void> _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(query: event.query, currentPage: 1));
    add(const LoadProductsEvent());
  }

  Future<void> _onApplyFilters(
    ApplyFiltersEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(
      categoryId: event.categoryId,
      materialType: event.materialType,
      finish: event.finish,
      color: event.color,
      originCountry: event.originCountry,
      featured: event.featured,
      active: event.active,
      currentPage: 1,
    ));
    add(const LoadProductsEvent());
  }

  Future<void> _onChangePage(
    ChangePageEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(currentPage: event.page));
    add(const LoadProductsEvent());
  }

  Future<void> _onChangeSort(
    ChangeSortEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(sortBy: event.sortBy, descending: event.descending));
    add(const LoadProductsEvent());
  }

  Future<void> _onGetProduct(
    GetProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.loading));
    final result = await getProduct(event.id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProductStatus.failure,
        errorMessage: 'Failed to load product details',
      )),
      (product) => emit(state.copyWith(
        status: ProductStatus.success,
        selectedProduct: product,
      )),
    );
  }

  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));
    final result = await createProduct(event.product);

    result.fold(
      (failure) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to create product',
      )),
      (product) {
        emit(state.copyWith(
          isSubmitting: false,
          status: ProductStatus.success,
        ));
        add(const LoadProductsEvent());
      },
    );
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));
    final result = await updateProduct(event.product);

    result.fold(
      (failure) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to update product',
      )),
      (product) {
        emit(state.copyWith(
          isSubmitting: false,
          selectedProduct: product,
          status: ProductStatus.success,
        ));
        add(const LoadProductsEvent());
      },
    );
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    final result = await deleteProduct(event.id);

    result.fold(
      (failure) => emit(state.copyWith(
        errorMessage: 'Failed to delete product',
      )),
      (_) {
        add(const LoadProductsEvent());
      },
    );
  }

  void _onToggleSelection(
    ToggleProductSelectionEvent event,
    Emitter<ProductState> emit,
  ) {
    final newSelection = Set<String>.from(state.selectedProductIds);
    if (newSelection.contains(event.productId)) {
      newSelection.remove(event.productId);
    } else {
      newSelection.add(event.productId);
    }
    emit(state.copyWith(selectedProductIds: newSelection));
  }

  void _onSelectAll(
    SelectAllProductsEvent event,
    Emitter<ProductState> emit,
  ) {
    final allIds = state.products.map((p) => p.id).toSet();
    emit(state.copyWith(selectedProductIds: allIds));
  }

  void _onClearSelection(
    ClearSelectionEvent event,
    Emitter<ProductState> emit,
  ) {
    emit(state.copyWith(selectedProductIds: {}));
  }

  Future<void> _onBulkDelete(
    BulkDeleteProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state.selectedProductIds.isEmpty) return;

    emit(state.copyWith(isSubmitting: true));
    final result = await repository.bulkDeleteProducts(state.selectedProductIds.toList());

    result.fold(
      (failure) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to delete selected products',
      )),
      (_) {
        emit(state.copyWith(
          isSubmitting: false,
          selectedProductIds: {},
        ));
        add(const LoadProductsEvent());
      },
    );
  }

  Future<void> _onBulkUpdateStatus(
    BulkUpdateStatusEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state.selectedProductIds.isEmpty) return;

    emit(state.copyWith(isSubmitting: true));
    final result = await repository.bulkUpdateStatus(
      state.selectedProductIds.toList(),
      active: event.active,
      featured: event.featured,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to update selected products',
      )),
      (_) {
        emit(state.copyWith(
          isSubmitting: false,
          selectedProductIds: {},
        ));
        add(const LoadProductsEvent());
      },
    );
  }
}
