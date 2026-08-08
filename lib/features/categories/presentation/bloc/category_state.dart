import 'package:equatable/equatable.dart';
import 'package:factory_management/features/categories/domain/entities/category.dart';

enum CategoryStatus { initial, loading, success, failure, submitting }

class CategoryState extends Equatable {
  final CategoryStatus status;
  final List<Category> categories;
  final Category? selectedCategory;
  final String? errorMessage;
  
  // Filters & Search
  final String query;
  final bool? active;
  final String? parentId;

  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categories = const [],
    this.selectedCategory,
    this.errorMessage,
    this.query = '',
    this.active,
    this.parentId,
  });

  CategoryState copyWith({
    CategoryStatus? status,
    List<Category>? categories,
    Category? selectedCategory,
    String? errorMessage,
    String? query,
    bool? active,
    String? parentId,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage ?? this.errorMessage,
      query: query ?? this.query,
      active: active ?? this.active,
      parentId: parentId ?? this.parentId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        categories,
        selectedCategory,
        errorMessage,
        query,
        active,
        parentId,
      ];
}
