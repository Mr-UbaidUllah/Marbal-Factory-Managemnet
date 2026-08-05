import 'package:factory_management/features/products/data/models/product_model.dart';
import 'package:uuid/uuid.dart';

abstract class ProductRemoteDataSource {
  Future<Map<String, dynamic>> getProducts({
    String? query,
    String? categoryId,
    String? materialType,
    String? finish,
    String? color,
    String? originCountry,
    bool? featured,
    bool? active,
    String? sortBy,
    bool? descending,
    int? page,
    int? limit,
  });

  Future<ProductModel> getProduct(String id);
  Future<ProductModel> createProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<bool> deleteProduct(String id);
  Future<bool> bulkDeleteProducts(List<String> ids);
  Future<bool> bulkUpdateStatus(List<String> ids, {bool? active, bool? featured});
  Future<List<String>> uploadImages(List<dynamic> images);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final List<ProductModel> _mockProducts = [
    ProductModel(
      id: '1',
      name: 'Italian Carrara Marble',
      slug: 'italian-carrara-marble',
      sku: 'MAR-CAR-001',
      categoryId: '1',
      categoryName: 'Marble',
      description: 'High-quality white marble from Carrara, Italy. Known for its elegant grey veining and luxurious finish.',
      shortDescription: 'Elegant white marble with grey veins.',
      price: 150.0,
      discountPrice: 135.0,
      stockQuantity: 500,
      minimumStock: 50,
      unit: 'sqm',
      dimensions: '300x150x2 cm',
      thickness: '2cm',
      finish: 'Polished',
      color: 'White',
      originCountry: 'Italy',
      materialType: 'Marble',
      weight: 55.0,
      waterAbsorption: '0.12%',
      hardness: '3 Mohs',
      application: 'Indoor, Wall, Floor',
      edgeType: 'Bevel',
      featured: true,
      active: true,
      images: ['https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800&q=80', 'https://images.unsplash.com/photo-1620641788421-7a1c342ea42e?w=800&q=80'],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
      createdBy: 'Admin',
    ),
    ProductModel(
      id: '2',
      name: 'Black Galaxy Granite',
      slug: 'black-galaxy-granite',
      sku: 'GRA-GALA-001',
      categoryId: '2',
      categoryName: 'Granite',
      description: 'Stunning black granite with golden speckles (bronzite), perfect for premium countertops and flooring.',
      shortDescription: 'Black granite with golden speckles.',
      price: 120.0,
      discountPrice: 110.0,
      stockQuantity: 300,
      minimumStock: 30,
      unit: 'sqm',
      dimensions: '280x160x3 cm',
      thickness: '3cm',
      finish: 'Polished',
      color: 'Black',
      originCountry: 'India',
      materialType: 'Granite',
      weight: 85.0,
      application: 'Kitchen Countertops, Flooring',
      waterAbsorption: '0.05%',
      hardness: '6.5 Mohs',
      featured: true,
      active: true,
      images: ['https://images.unsplash.com/photo-1628592102751-ba83b03a44e0?w=800&q=80'],
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now(),
      createdBy: 'Admin',
    ),
    ProductModel(
      id: '3',
      name: 'White Onyx Premium',
      slug: 'white-onyx-premium',
      sku: 'ONY-WHI-001',
      categoryId: '3',
      categoryName: 'Onyx',
      description: 'Translucent white onyx with golden and amber veins. Ideal for backlit architectural features.',
      shortDescription: 'Translucent white onyx for backlighting.',
      price: 450.0,
      discountPrice: 400.0,
      stockQuantity: 50,
      minimumStock: 10,
      unit: 'sqm',
      dimensions: '240x140x2 cm',
      thickness: '2cm',
      finish: 'Polished',
      color: 'White',
      originCountry: 'Iran',
      materialType: 'Onyx',
      weight: 50.0,
      application: 'Wall Cladding, Decorative Features',
      featured: false,
      active: true,
      images: ['https://images.unsplash.com/photo-1620641788421-7a1c342ea42e?w=800&q=80'],
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now(),
    ),
    ProductModel(
      id: '4',
      name: 'Travertine Classic',
      slug: 'travertine-classic',
      sku: 'TRA-CLA-001',
      categoryId: '4',
      categoryName: 'Travertine',
      description: 'Classic beige travertine with natural characteristic pits. Often used for a rustic or Mediterranean look.',
      shortDescription: 'Beige natural travertine.',
      price: 85.0,
      discountPrice: 85.0,
      stockQuantity: 800,
      minimumStock: 100,
      unit: 'sqm',
      dimensions: '60x60x1.2 cm',
      thickness: '1.2cm',
      finish: 'Honed & Filled',
      color: 'Beige',
      originCountry: 'Turkey',
      materialType: 'Travertine',
      weight: 35.0,
      application: 'Flooring, Outdoor Patio',
      featured: false,
      active: true,
      images: ['https://images.unsplash.com/photo-1590272456521-1bbe160a18ce?w=800&q=80'],
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now(),
    ),
    ProductModel(
      id: '5',
      name: 'Rosso Verona',
      slug: 'rosso-verona',
      sku: 'MAR-ROS-001',
      categoryId: '1',
      categoryName: 'Marble',
      description: 'Distinctive red marble with white veins from the Verona region of Italy. Used since ancient Roman times.',
      shortDescription: 'Deep red Italian marble.',
      price: 180.0,
      discountPrice: 180.0,
      stockQuantity: 10,
      minimumStock: 20,
      unit: 'sqm',
      dimensions: '300x150x2 cm',
      thickness: '2cm',
      finish: 'Polished',
      color: 'Red',
      originCountry: 'Italy',
      materialType: 'Marble',
      weight: 55.0,
      featured: false,
      active: true,
      images: ['https://images.unsplash.com/photo-1590272456521-1bbe160a18ce?w=800&q=80'],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
    ),
    ProductModel(
      id: '6',
      name: 'Crema Marfil',
      slug: 'crema-marfil',
      sku: 'MAR-CRE-001',
      categoryId: '1',
      categoryName: 'Marble',
      description: 'The most popular beige marble in the world. Creamy background with subtle yellow/orange veins.',
      shortDescription: 'Popular Spanish beige marble.',
      price: 95.0,
      discountPrice: 90.0,
      stockQuantity: 1200,
      minimumStock: 200,
      unit: 'sqm',
      dimensions: '60x60x2 cm',
      thickness: '2cm',
      finish: 'Polished',
      color: 'Beige',
      originCountry: 'Spain',
      materialType: 'Marble',
      weight: 56.0,
      featured: true,
      active: true,
      images: ['https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800&q=80'],
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  Future<Map<String, dynamic>> getProducts({
    String? query,
    String? categoryId,
    String? materialType,
    String? finish,
    String? color,
    String? originCountry,
    bool? featured,
    bool? active,
    String? sortBy,
    bool? descending,
    int? page = 1,
    int? limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var products = _mockProducts.where((p) => !p.isDeleted).toList();

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      products = products.where((p) => 
        p.name.toLowerCase().contains(q) || 
        p.sku.toLowerCase().contains(q) ||
        p.materialType.toLowerCase().contains(q) ||
        p.color.toLowerCase().contains(q) ||
        p.originCountry.toLowerCase().contains(q)
      ).toList();
    }

    if (categoryId != null) products = products.where((p) => p.categoryId == categoryId).toList();
    if (materialType != null) products = products.where((p) => p.materialType == materialType).toList();
    if (finish != null) products = products.where((p) => p.finish == finish).toList();
    if (color != null) products = products.where((p) => p.color == color).toList();
    if (originCountry != null) products = products.where((p) => p.originCountry == originCountry).toList();
    if (featured != null) products = products.where((p) => p.featured == featured).toList();
    if (active != null) products = products.where((p) => p.active == active).toList();

    if (sortBy != null) {
      products.sort((a, b) {
        int cmp;
        switch (sortBy) {
          case 'name': cmp = a.name.compareTo(b.name); break;
          case 'price': cmp = a.price.compareTo(b.price); break;
          case 'stock': cmp = a.stockQuantity.compareTo(b.stockQuantity); break;
          case 'createdAt': cmp = a.createdAt.compareTo(b.createdAt); break;
          default: cmp = 0;
        }
        return descending == true ? -cmp : cmp;
      });
    }

    final total = products.length;
    final start = ((page ?? 1) - 1) * (limit ?? 10);
    final end = start + (limit ?? 10);
    final paginated = products.sublist(
      start > total ? total : start,
      end > total ? total : end,
    );

    return {'products': paginated, 'total': total, 'page': page, 'limit': limit};
  }

  @override
  Future<ProductModel> getProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockProducts.firstWhere((p) => p.id == id);
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _mockProducts.add(product);
    return product;
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _mockProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) _mockProducts[index] = product;
    return product;
  }

  @override
  Future<bool> deleteProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockProducts.indexWhere((p) => p.id == id);
    if (index != -1) {
      _mockProducts[index] = ProductModel.fromEntity(
        _mockProducts[index].copyWith(isDeleted: true, deletedAt: DateTime.now())
      );
    }
    return true;
  }

  @override
  Future<bool> bulkDeleteProducts(List<String> ids) async {
    await Future.delayed(const Duration(milliseconds: 800));
    for (var id in ids) {
      final index = _mockProducts.indexWhere((p) => p.id == id);
      if (index != -1) {
        _mockProducts[index] = ProductModel.fromEntity(
          _mockProducts[index].copyWith(isDeleted: true, deletedAt: DateTime.now())
        );
      }
    }
    return true;
  }

  @override
  Future<bool> bulkUpdateStatus(List<String> ids, {bool? active, bool? featured}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    for (var id in ids) {
      final index = _mockProducts.indexWhere((p) => p.id == id);
      if (index != -1) {
        _mockProducts[index] = ProductModel.fromEntity(
          _mockProducts[index].copyWith(
            active: active ?? _mockProducts[index].active,
            featured: featured ?? _mockProducts[index].featured,
            updatedAt: DateTime.now(),
          )
        );
      }
    }
    return true;
  }

  @override
  Future<List<String>> uploadImages(List<dynamic> images) async {
    await Future.delayed(const Duration(seconds: 1));
    return images.map((_) => 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800&q=80').toList();
  }
}
