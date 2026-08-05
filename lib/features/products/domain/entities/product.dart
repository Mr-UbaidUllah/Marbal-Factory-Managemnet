import 'package:equatable/equatable.dart';

enum ProductStatus {
  inStock,
  lowStock,
  outOfStock,
  inactive,
  featured,
  draft,
  archived,
}

class Product extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String sku;
  final String categoryId;
  final String categoryName;
  final String description;
  final String shortDescription;
  final double price;
  final double discountPrice;
  final int stockQuantity;
  final int minimumStock;
  final String unit; // sqm, pieces, etc.
  
  // Specifications
  final String dimensions;
  final String thickness;
  final String finish;
  final String color;
  final String originCountry;
  final String materialType;
  final double weight;
  
  // Advanced Specifications
  final String? waterAbsorption;
  final String? hardness;
  final String? application; // Indoor, Outdoor, Wall, Floor
  final String? edgeType;
  
  final bool featured;
  final bool active;
  final List<String> images;
  
  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final String? lastUpdatedBy;
  final bool isDeleted;
  final DateTime? deletedAt;

  // Variants Architecture (Future-ready)
  final List<String>? variantIds;
  final String? parentProductId;

  const Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.sku,
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.shortDescription,
    required this.price,
    required this.discountPrice,
    required this.stockQuantity,
    required this.minimumStock,
    required this.unit,
    required this.dimensions,
    required this.thickness,
    required this.finish,
    required this.color,
    required this.originCountry,
    required this.materialType,
    required this.weight,
    this.waterAbsorption,
    this.hardness,
    this.application,
    this.edgeType,
    required this.featured,
    required this.active,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.lastUpdatedBy,
    this.isDeleted = false,
    this.deletedAt,
    this.variantIds,
    this.parentProductId,
  });

  ProductStatus get status {
    if (isDeleted) return ProductStatus.archived;
    if (!active) return ProductStatus.inactive;
    if (stockQuantity <= 0) return ProductStatus.outOfStock;
    if (stockQuantity <= minimumStock) return ProductStatus.lowStock;
    return ProductStatus.inStock;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        sku,
        categoryId,
        categoryName,
        description,
        shortDescription,
        price,
        discountPrice,
        stockQuantity,
        minimumStock,
        unit,
        dimensions,
        thickness,
        finish,
        color,
        originCountry,
        materialType,
        weight,
        waterAbsorption,
        hardness,
        application,
        edgeType,
        featured,
        active,
        images,
        createdAt,
        updatedAt,
        createdBy,
        lastUpdatedBy,
        isDeleted,
        deletedAt,
        variantIds,
        parentProductId,
      ];

  Product copyWith({
    String? id,
    String? name,
    String? slug,
    String? sku,
    String? categoryId,
    String? categoryName,
    String? description,
    String? shortDescription,
    double? price,
    double? discountPrice,
    int? stockQuantity,
    int? minimumStock,
    String? unit,
    String? dimensions,
    String? thickness,
    String? finish,
    String? color,
    String? originCountry,
    String? materialType,
    double? weight,
    String? waterAbsorption,
    String? hardness,
    String? application,
    String? edgeType,
    bool? featured,
    bool? active,
    List<String>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? lastUpdatedBy,
    bool? isDeleted,
    DateTime? deletedAt,
    List<String>? variantIds,
    String? parentProductId,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      sku: sku ?? this.sku,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      minimumStock: minimumStock ?? this.minimumStock,
      unit: unit ?? this.unit,
      dimensions: dimensions ?? this.dimensions,
      thickness: thickness ?? this.thickness,
      finish: finish ?? this.finish,
      color: color ?? this.color,
      originCountry: originCountry ?? this.originCountry,
      materialType: materialType ?? this.materialType,
      weight: weight ?? this.weight,
      waterAbsorption: waterAbsorption ?? this.waterAbsorption,
      hardness: hardness ?? this.hardness,
      application: application ?? this.application,
      edgeType: edgeType ?? this.edgeType,
      featured: featured ?? this.featured,
      active: active ?? this.active,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      variantIds: variantIds ?? this.variantIds,
      parentProductId: parentProductId ?? this.parentProductId,
    );
  }
}
