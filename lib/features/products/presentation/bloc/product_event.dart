import 'package:equatable/equatable.dart';
import 'package:factory_management/features/products/domain/entities/product.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductsEvent extends ProductEvent {
  final bool refresh;

  const LoadProductsEvent({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class SearchProductsEvent extends ProductEvent {
  final String query;

  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ApplyFiltersEvent extends ProductEvent {
  final String? categoryId;
  final String? materialType;
  final String? finish;
  final String? color;
  final String? originCountry;
  final bool? featured;
  final bool? active;

  const ApplyFiltersEvent({
    this.categoryId,
    this.materialType,
    this.finish,
    this.color,
    this.originCountry,
    this.featured,
    this.active,
  });

  @override
  List<Object?> get props => [
        categoryId,
        materialType,
        finish,
        color,
        originCountry,
        featured,
        active,
      ];
}

class ChangePageEvent extends ProductEvent {
  final int page;

  const ChangePageEvent(this.page);

  @override
  List<Object?> get props => [page];
}

class ChangeSortEvent extends ProductEvent {
  final String sortBy;
  final bool descending;

  const ChangeSortEvent(this.sortBy, this.descending);

  @override
  List<Object?> get props => [sortBy, descending];
}

class GetProductEvent extends ProductEvent {
  final String id;

  const GetProductEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateProductEvent extends ProductEvent {
  final Product product;

  const CreateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateProductEvent extends ProductEvent {
  final Product product;

  const UpdateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class DeleteProductEvent extends ProductEvent {
  final String id;

  const DeleteProductEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleProductSelectionEvent extends ProductEvent {
  final String productId;

  const ToggleProductSelectionEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class SelectAllProductsEvent extends ProductEvent {
  const SelectAllProductsEvent();
}

class ClearSelectionEvent extends ProductEvent {
  const ClearSelectionEvent();
}

class BulkDeleteProductsEvent extends ProductEvent {
  const BulkDeleteProductsEvent();
}

class BulkUpdateStatusEvent extends ProductEvent {
  final bool? active;
  final bool? featured;

  const BulkUpdateStatusEvent({this.active, this.featured});

  @override
  List<Object?> get props => [active, featured];
}

class UploadProductImagesEvent extends ProductEvent {
  final List<dynamic> images;

  const UploadProductImagesEvent(this.images);

  @override
  List<Object?> get props => [images];
}
