import 'package:factory_management/features/products/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.images,
    required super.categoryId,
    required super.categoryName,
    required super.material,
    required super.origin,
    required super.color,
    required super.finish,
    required super.isAvailable,
    required super.stockQuantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      images: List<String>.from(json['images'] as List),
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      material: json['material'] as String,
      origin: json['origin'] as String,
      color: json['color'] as String,
      finish: json['finish'] as String,
      isAvailable: json['isAvailable'] as bool,
      stockQuantity: (json['stockQuantity'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'material': material,
      'origin': origin,
      'color': color,
      'finish': finish,
      'isAvailable': isAvailable,
      'stockQuantity': stockQuantity,
    };
  }
}
