import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:factory_management/features/categories/domain/usecases/get_categories.dart';
import 'package:factory_management/features/categories/domain/usecases/get_category.dart';
import 'package:factory_management/features/categories/domain/usecases/create_category.dart';
import 'package:factory_management/features/categories/domain/usecases/update_category.dart';
import 'package:factory_management/features/categories/domain/usecases/delete_category.dart';
import 'package:factory_management/features/categories/domain/usecases/toggle_category_status.dart';
import 'package:factory_management/features/categories/domain/usecases/reorder_categories.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategories getCategories;
  final GetCategory getCategory;
  final CreateCategory createCategory;
  final UpdateCategory updateCategory;
  final DeleteCategory deleteCategory;
  final ToggleCategoryStatus toggleCategoryStatus;
  final ReorderCategories reorderCategories;

  CategoryBloc({
    required this.getCategories,
    required this.getCategory,
    required this.createCategory,
    required this.updateCategory,
    required this.deleteCategory,
    required this.toggleCategoryStatus,
    required this.reorderCategories,
  }) : super(const CategoryState()) {
    on<LoadCategories>(_onLoadCategories);
    on<RefreshCategories>(_onRefreshCategories);
    on<GetCategoryEvent>(_onGetCategory);
    on<CreateCategoryEvent>(_onCreateCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    on<ToggleCategoryStatusEvent>(_onToggleCategoryStatus);
    on<ReorderCategoriesEvent>(_onReorderCategories);
    on<SearchCategoriesEvent>(_onSearchCategories);
    on<FilterCategoriesEvent>(_onFilterCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading));
    
    final result = await getCategories(
      query: event.query ?? state.query,
      active: event.active ?? state.active,
      parentId: event.parentId ?? state.parentId,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: CategoryStatus.failure,
        errorMessage: failure.message,
      )),
      (categories) => emit(state.copyWith(
        status: CategoryStatus.success,
        categories: categories,
      )),
    );
  }

  Future<void> _onRefreshCategories(
    RefreshCategories event,
    Emitter<CategoryState> emit,
  ) async {
    add(LoadCategories(
      query: state.query,
      active: state.active,
      parentId: state.parentId,
    ));
  }

  Future<void> _onGetCategory(
    GetCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading));
    final result = await getCategory(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: CategoryStatus.failure,
        errorMessage: failure.message,
      )),
      (category) => emit(state.copyWith(
        status: CategoryStatus.success,
        selectedCategory: category,
      )),
    );
  }

  Future<void> _onCreateCategory(
    CreateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.submitting));
    final result = await createCategory(event.category);
    result.fold(
      (failure) => emit(state.copyWith(
        status: CategoryStatus.failure,
        errorMessage: failure.message,
      )),
      (category) {
        emit(state.copyWith(status: CategoryStatus.success));
        add(RefreshCategories());
      },
    );
  }

  Future<void> _onUpdateCategory(
    UpdateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.submitting));
    final result = await updateCategory(event.category);
    result.fold(
      (failure) => emit(state.copyWith(
        status: CategoryStatus.failure,
        errorMessage: failure.message,
      )),
      (category) {
        emit(state.copyWith(status: CategoryStatus.success));
        add(RefreshCategories());
      },
    );
  }

  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.submitting));
    final result = await deleteCategory(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: CategoryStatus.failure,
        errorMessage: failure.message,
      )),
      (success) {
        emit(state.copyWith(status: CategoryStatus.success));
        add(RefreshCategories());
      },
    );
  }

  Future<void> _onToggleCategoryStatus(
    ToggleCategoryStatusEvent event,
    Emitter<CategoryState> emit,
  ) async {
    final result = await toggleCategoryStatus(event.id, event.active);
    result.fold(
      (failure) => emit(state.copyWith(
        status: CategoryStatus.failure,
        errorMessage: failure.message,
      )),
      (success) => add(RefreshCategories()),
    );
  }

  Future<void> _onReorderCategories(
    ReorderCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    final result = await reorderCategories(event.orderedIds);
    result.fold(
      (failure) => emit(state.copyWith(
        status: CategoryStatus.failure,
        errorMessage: failure.message,
      )),
      (success) => add(RefreshCategories()),
    );
  }

  Future<void> _onSearchCategories(
    SearchCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(query: event.query));
    add(LoadCategories(query: event.query));
  }

  Future<void> _onFilterCategories(
    FilterCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(active: event.active));
    add(LoadCategories(active: event.active));
  }
}
