import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/exception_mapper.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/products/data/models/product_model.dart';
import 'package:factory_management/features/products/domain/entities/product.dart';
import 'package:factory_management/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  // Mock data for initial implementation
  final List<ProductModel> _mockProducts = [
    ProductModel(
      id: '1',
      name: 'White Marble',
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
  Future<Either<Failure, List<Product>>> getProducts({
    String? categoryId,
    String? searchQuery,
    String? sortBy,
    bool descending = false,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      var results = _mockProducts.where((product) {
        bool matchesCategory = categoryId == null || product.categoryId == categoryId;
        bool matchesSearch = searchQuery == null || 
            product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            product.material.toLowerCase().contains(searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();

      return Right(results);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final product = _mockProducts.firstWhere((p) => p.id == id);
      return Right(product);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getRelatedProducts(String productId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final product = _mockProducts.firstWhere((p) => p.id == productId);
      final related = _mockProducts.where((p) => p.categoryId == product.categoryId && p.id != productId).toList();
      return Right(related);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getFeaturedProducts() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return Right(_mockProducts.take(4).toList());
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }
}
