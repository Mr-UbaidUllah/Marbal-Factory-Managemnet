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
    // In a real app, this would be:
    // final response = await client.get(ApiEndpoints.getProducts);
    // return (response.data as List).map((e) => ProductModel.fromJson(e)).toList();

    // Mocking for now as per "preserve existing design" and "transform UI"
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
        name: 'Black Galaxy',
        category: 'Granite',
        origin: 'India',
        image: 'https://images.unsplash.com/photo-1590273332324-214972f3f69b?q=80&w=1000&auto=format&fit=crop',
        price: 'From \$120/sqm',
        rating: 4.8,
      ),
      const ProductModel(
        name: 'Royal White',
        category: 'Quartz',
        origin: 'Vietnam',
        image: 'https://images.unsplash.com/photo-1615529328331-f8917597711f?q=80&w=1000&auto=format&fit=crop',
        price: 'From \$180/sqm',
        rating: 4.9,
      ),
      const ProductModel(
        name: 'Golden Spider',
        category: 'Marble',
        origin: 'Greece',
        image: 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?q=80&w=1000&auto=format&fit=crop',
        price: 'From \$210/sqm',
        rating: 5.0,
      ),
    ];
  }

  @override
  Future<void> submitQuoteRequest(Map<String, dynamic> quoteData) async {
    // await client.post(ApiEndpoints.submitQuote, data: quoteData);
    await Future.delayed(const Duration(seconds: 1));
  }
}
