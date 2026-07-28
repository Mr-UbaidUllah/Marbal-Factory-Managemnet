import 'package:factory_management/features/website/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.name,
    required super.category,
    required super.origin,
    required super.image,
    required super.price,
    required super.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] as String,
      category: json['category'] as String,
      origin: json['origin'] as String,
      image: json['image'] as String,
      price: json['price'] as String,
      rating: (json['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'origin': origin,
      'image': image,
      'price': price,
      'rating': rating,
    };
  }
}
