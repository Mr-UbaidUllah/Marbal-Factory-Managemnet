import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String name;
  final String category;
  final String origin;
  final String image;
  final String price;
  final double rating;

  const Product({
    required this.name,
    required this.category,
    required this.origin,
    required this.image,
    required this.price,
    required this.rating,
  });

  @override
  List<Object?> get props => [name, category, origin, image, price, rating];
}
