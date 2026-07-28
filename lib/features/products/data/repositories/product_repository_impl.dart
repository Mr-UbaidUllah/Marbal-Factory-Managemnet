import 'package:factory_management/features/products/data/models/product_model.dart';
import 'package:factory_management/features/products/domain/entities/product.dart';
import 'package:factory_management/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  // Mock data for initial implementation
  final List<ProductModel> _mockProducts = [
    ProductModel(
      id: '1',
      name: 'Carrara White Marble',
      description: 'Classic white marble with grey veining, perfect for countertops and flooring.',
      price: 150.0,
      images: ['https://example.com/carrara.jpg'],
      categoryId: '1',
      categoryName: 'Marble',
      material: 'Marble',
      origin: 'Italy',
      color: 'White',
      finish: 'Polished',
      isAvailable: true,
      stockQuantity: 500.0,
    ),
    ProductModel(
      id: '2',
      name: 'Black Galaxy Granite',
      description: 'Stunning black granite with golden specks, highly durable for kitchen use.',
      price: 120.0,
      images: ['https://example.com/black_galaxy.jpg'],
      categoryId: '2',
      categoryName: 'Granite',
      material: 'Granite',
      origin: 'India',
      color: 'Black',
      finish: 'Polished',
      isAvailable: true,
      stockQuantity: 300.0,
    ),
  ];

  @override
  Future<List<Product>> getProducts({
    String? categoryId,
    String? searchQuery,
    String? sortBy,
    bool descending = false,
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    var results = _mockProducts.where((product) {
      bool matchesCategory = categoryId == null || product.categoryId == categoryId;
      bool matchesSearch = searchQuery == null || 
          product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          product.material.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    // Sorting and pagination logic would go here
    
    return results;
  }

  @override
  Future<Product> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockProducts.firstWhere((p) => p.id == id);
  }

  @override
  Future<List<Product>> getRelatedProducts(String productId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final product = _mockProducts.firstWhere((p) => p.id == productId);
    return _mockProducts.where((p) => p.categoryId == product.categoryId && p.id != productId).toList();
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockProducts.take(4).toList();
  }
}
