import 'package:equatable/equatable.dart';
import 'package:factory_management/features/categories/domain/entities/category.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {
  final String? query;
  final bool? active;
  final String? parentId;

  const LoadCategories({this.query, this.active, this.parentId});

  @override
  List<Object?> get props => [query, active, parentId];
}

class RefreshCategories extends CategoryEvent {}

class GetCategoryEvent extends CategoryEvent {
  final String id;

  const GetCategoryEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateCategoryEvent extends CategoryEvent {
  final Category category;

  const CreateCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class UpdateCategoryEvent extends CategoryEvent {
  final Category category;

  const UpdateCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class DeleteCategoryEvent extends CategoryEvent {
  final String id;

  const DeleteCategoryEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleCategoryStatusEvent extends CategoryEvent {
  final String id;
  final bool active;

  const ToggleCategoryStatusEvent(this.id, this.active);

  @override
  List<Object?> get props => [id, active];
}

class ReorderCategoriesEvent extends CategoryEvent {
  final List<String> orderedIds;

  const ReorderCategoriesEvent(this.orderedIds);

  @override
  List<Object?> get props => [orderedIds];
}

class SearchCategoriesEvent extends CategoryEvent {
  final String query;

  const SearchCategoriesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterCategoriesEvent extends CategoryEvent {
  final bool? active;

  const FilterCategoriesEvent(this.active);

  @override
  List<Object?> get props => [active];
}
