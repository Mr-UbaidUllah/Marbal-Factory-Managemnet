import 'package:factory_management/core/network/api_client.dart';
import 'package:factory_management/features/website/data/models/product_model.dart';
import 'package:factory_management/features/website/data/models/project_model.dart';

abstract class WebsiteRemoteDataSource {
  Future<List<ProductModel>> getFeaturedProducts();
  Future<void> submitQuoteRequest(Map<String, dynamic> quoteData);
  Future<List<ProjectModel>> getProjects();
  Future<ProjectModel> getProjectById(String id);
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
    ];
  }

  @override
  Future<void> submitQuoteRequest(Map<String, dynamic> quoteData) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<List<ProjectModel>> getProjects() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ProjectModel(
        id: '1',
        title: 'The Grand Plaza Hotel',
        description: 'A comprehensive marble installation for the lobby and suites of the Grand Plaza Hotel, featuring premium Calacatta and Nero Marquina.',
        location: 'Dubai, UAE',
        projectType: 'Hotel',
        completionDate: DateTime(2023, 5, 15),
        coverImage: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?q=80&w=1000&auto=format&fit=crop',
        galleryImages: const [
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?q=80&w=1000&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=1000&auto=format&fit=crop',
        ],
        materialsUsed: const ['Calacatta Marble', 'Nero Marquina', 'Granite Giallo'],
        featured: true,
        active: true,
      ),
      ProjectModel(
        id: '2',
        title: 'Luxury Villa Skyline',
        description: 'Modern residential project utilizing exotic stones for flooring and wall cladding.',
        location: 'Doha, Qatar',
        projectType: 'Residential',
        completionDate: DateTime(2023, 8, 20),
        coverImage: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?q=80&w=1000&auto=format&fit=crop',
        galleryImages: const [
          'https://images.unsplash.com/photo-1613490493576-7fde63acd811?q=80&w=1000&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=1000&auto=format&fit=crop',
        ],
        materialsUsed: const ['Carrara White', 'Statuary Marble'],
        featured: true,
        active: true,
      ),
      ProjectModel(
        id: '3',
        title: 'Modern Office Complex',
        description: 'Sleek granite facades and marble reception area for a high-end corporate office.',
        location: 'Riyadh, Saudi Arabia',
        projectType: 'Office',
        completionDate: DateTime(2024, 1, 10),
        coverImage: 'https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=1000&auto=format&fit=crop',
        galleryImages: const [
          'https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=1000&auto=format&fit=crop',
        ],
        materialsUsed: const ['Absolute Black Granite', 'Grey Marble'],
        featured: false,
        active: true,
      ),
    ];
  }

  @override
  Future<ProjectModel> getProjectById(String id) async {
    final projects = await getProjects();
    return projects.firstWhere((p) => p.id == id);
  }
}
