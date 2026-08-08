import 'package:factory_management/features/categories/data/models/category_model.dart';
import 'package:uuid/uuid.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories({
    String? query,
    bool? active,
    String? parentId,
  });

  Future<CategoryModel> getCategory(String id);
  Future<CategoryModel> createCategory(CategoryModel category);
  Future<CategoryModel> updateCategory(CategoryModel category);
  Future<bool> deleteCategory(String id);
  Future<bool> toggleCategoryStatus(String id, bool active);
  Future<bool> reorderCategories(List<String> orderedIds);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final List<CategoryModel> _mockCategories = [
    CategoryModel(
      id: '1',
      name: 'Marble',
      slug: 'marble',
      description: 'Natural stone formed from limestone with beautiful veining.',
      image: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800&q=80',
      productCount: 42,
      active: true,
      sortOrder: 0,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
      updatedAt: DateTime.now(),
    ),
    CategoryModel(
      id: '2',
      name: 'Granite',
      slug: 'granite',
      description: 'Durable and hard volcanic rock, perfect for countertops.',
      image: 'https://images.unsplash.com/photo-1628592102751-ba83b03a44e0?w=800&q=80',
      productCount: 31,
      active: true,
      sortOrder: 1,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      updatedAt: DateTime.now(),
    ),
    CategoryModel(
      id: '3',
      name: 'Onyx',
      slug: 'onyx',
      description: 'Translucent stone often used for decorative and backlit features.',
      image: 'https://images.unsplash.com/photo-1620641788421-7a1c342ea42e?w=800&q=80',
      productCount: 12,
      active: true,
      sortOrder: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 80)),
      updatedAt: DateTime.now(),
    ),
    CategoryModel(
      id: '4',
      name: 'Travertine',
      slug: 'travertine',
      description: 'A form of terrestrial limestone deposited around mineral springs.',
      image: 'https://images.unsplash.com/photo-1590272456521-1bbe160a18ce?w=800&q=80',
      productCount: 8,
      active: true,
      sortOrder: 3,
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now(),
    ),
    CategoryModel(
      id: '5',
      name: 'Quartz',
      slug: 'quartz',
      description: 'Engineered stone known for its consistency and durability.',
      image: 'https://images.unsplash.com/photo-1615529328331-f8917597711f?w=800&q=80',
      productCount: 25,
      active: true,
      sortOrder: 4,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  Future<List<CategoryModel>> getCategories({
    String? query,
    bool? active,
    String? parentId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var categories = List<CategoryModel>.from(_mockCategories);

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      categories = categories.where((c) => 
        c.name.toLowerCase().contains(q) || 
        (c.description?.toLowerCase().contains(q) ?? false)
      ).toList();
    }

    if (active != null) {
      categories = categories.where((c) => c.active == active).toList();
    }

    if (parentId != null) {
      categories = categories.where((c) => c.parentId == parentId).toList();
    } else {
      categories = categories.where((c) => c.parentId == null).toList();
    }

    categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return categories;
  }

  @override
  Future<CategoryModel> getCategory(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockCategories.firstWhere((c) => c.id == id);
  }

  @override
  Future<CategoryModel> createCategory(CategoryModel category) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newCategory = CategoryModel(
      id: const Uuid().v4(),
      name: category.name,
      slug: category.slug,
      description: category.description,
      image: category.image,
      parentId: category.parentId,
      productCount: 0,
      active: category.active,
      sortOrder: _mockCategories.length,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _mockCategories.add(newCategory);
    return newCategory;
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _mockCategories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      final updated = CategoryModel.fromEntity(category.copyWith(updatedAt: DateTime.now()));
      _mockCategories[index] = updated;
      return updated;
    }
    throw Exception('Category not found');
  }

  @override
  Future<bool> deleteCategory(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockCategories.indexWhere((c) => c.id == id);
    if (index != -1) {
      if (_mockCategories[index].productCount > 0) {
        throw Exception('Cannot delete category with products');
      }
      _mockCategories.removeAt(index);
      return true;
    }
    return false;
  }

  @override
  Future<bool> toggleCategoryStatus(String id, bool active) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockCategories.indexWhere((c) => c.id == id);
    if (index != -1) {
      _mockCategories[index] = CategoryModel.fromEntity(
        _mockCategories[index].copyWith(active: active, updatedAt: DateTime.now())
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> reorderCategories(List<String> orderedIds) async {
    await Future.delayed(const Duration(milliseconds: 500));
    for (int i = 0; i < orderedIds.length; i++) {
      final index = _mockCategories.indexWhere((c) => c.id == orderedIds[i]);
      if (index != -1) {
        _mockCategories[index] = CategoryModel.fromEntity(
          _mockCategories[index].copyWith(sortOrder: i)
        );
      }
    }
    return true;
  }
}
