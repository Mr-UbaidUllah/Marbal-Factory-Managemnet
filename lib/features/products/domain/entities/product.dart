import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String categoryId;
  final String categoryName;
  final String material;
  final String origin;
  final String color;
  final String finish;
  final bool isAvailable;
  final double stockQuantity;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.categoryId,
    required this.categoryName,
    required this.material,
    required this.origin,
    required this.color,
    required this.finish,
    required this.isAvailable,
    required this.stockQuantity,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        images,
        categoryId,
        categoryName,
        material,
        origin,
        color,
        finish,
        isAvailable,
        stockQuantity,
      ];
}
