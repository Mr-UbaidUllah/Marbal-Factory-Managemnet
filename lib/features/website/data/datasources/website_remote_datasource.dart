import 'package:factory_management/core/network/api_client.dart';
import 'package:factory_management/core/network/api_endpoints.dart';
import 'package:factory_management/features/website/data/models/product_model.dart';

abstract class WebsiteRemoteDataSource {
  Future<List<ProductModel>> getFeaturedProducts();
  Future<void> submitQuoteRequest(Map<String, dynamic> quoteData);
}

class WebsiteRemoteDataSourceImpl implements WebsiteRemoteDataSource {
  final ApiClient client;

  WebsiteRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const ProductModel(
        name: 'Calacatta Borghini',
        category: 'Marble',
        origin: 'Italy',
        image: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?q=80&w=1000&auto=format&fit=crop',
        price: 'From \$250/sqm',
        rating: 5.0,
      ),
      const ProductModel(
        name: 'Nero Marquina',
        category: 'Marble',
        origin: 'Spain',
        image: 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?q=80&w=1000&auto=format&fit=crop',
        price: 'From \$190/sqm',
        rating: 4.8,
      ),
      const ProductModel(
        name: 'Carrara White',
        category: 'Marble',
        origin: 'Italy',
        image: 'https://images.unsplash.com/photo-1615529328331-f8917597711f?q=80&w=1000&auto=format&fit=crop',
        price: 'From \$180/sqm',
        rating: 4.9,
      ),
      const ProductModel(
        name: 'Emerald Quartz',
        category: 'Quartz',
        origin: 'Brazil',
        image: 'https://images.unsplash.com/photo-1599619351208-3e6c839d7824?q=80&w=1000&auto=format&fit=crop',
        price: 'From \$210/sqm',
        rating: 5.0,
      ),
    ];
  }

  @override
  Future<void> submitQuoteRequest(Map<String, dynamic> quoteData) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
