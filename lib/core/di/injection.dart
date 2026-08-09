import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:factory_management/core/network/api_client.dart';
import 'package:factory_management/core/network/network_interceptor.dart';

// Auth
import 'package:factory_management/features/authentication/data/datasources/auth_local_datasource.dart';
import 'package:factory_management/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:factory_management/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:factory_management/features/authentication/domain/repositories/auth_repository.dart';
import 'package:factory_management/features/authentication/domain/usecases/login_usecase.dart';
import 'package:factory_management/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:factory_management/features/authentication/domain/usecases/get_current_user_usecase.dart';
import 'package:factory_management/features/authentication/domain/usecases/check_auth_usecase.dart';
import 'package:factory_management/features/authentication/presentation/bloc/auth_bloc.dart';

// Website
import 'package:factory_management/features/website/data/datasources/website_remote_datasource.dart';
import 'package:factory_management/features/website/data/repositories/website_repository_impl.dart';
import 'package:factory_management/features/website/domain/repositories/website_repository.dart';
import 'package:factory_management/features/website/domain/usecases/get_featured_products_usecase.dart';
import 'package:factory_management/features/website/domain/usecases/submit_quote_usecase.dart';
import 'package:factory_management/features/website/presentation/bloc/website_bloc.dart';

// Dashboard
import 'package:factory_management/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:factory_management/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:factory_management/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:factory_management/features/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';
import 'package:factory_management/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:factory_management/features/dashboard/presentation/bloc/navigation_bloc.dart';

// Categories
import 'package:factory_management/features/categories/data/datasources/category_remote_datasource.dart';
import 'package:factory_management/features/categories/data/repositories/category_repository_impl.dart';
import 'package:factory_management/features/categories/domain/repositories/category_repository.dart';
import 'package:factory_management/features/categories/domain/usecases/get_categories.dart';
import 'package:factory_management/features/categories/domain/usecases/get_category.dart';
import 'package:factory_management/features/categories/domain/usecases/create_category.dart';
import 'package:factory_management/features/categories/domain/usecases/update_category.dart';
import 'package:factory_management/features/categories/domain/usecases/delete_category.dart';
import 'package:factory_management/features/categories/domain/usecases/toggle_category_status.dart';
import 'package:factory_management/features/categories/domain/usecases/reorder_categories.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_bloc.dart';

// Products
import 'package:factory_management/features/products/data/datasources/product_remote_datasource.dart';
import 'package:factory_management/features/products/data/repositories/product_repository_impl.dart';
import 'package:factory_management/features/products/domain/repositories/product_repository.dart';
import 'package:factory_management/features/products/domain/usecases/get_products.dart';
import 'package:factory_management/features/products/domain/usecases/get_product.dart';
import 'package:factory_management/features/products/domain/usecases/create_product.dart';
import 'package:factory_management/features/products/domain/usecases/update_product.dart';
import 'package:factory_management/features/products/domain/usecases/delete_product.dart';
import 'package:factory_management/features/products/domain/usecases/bulk_delete_products.dart';
import 'package:factory_management/features/products/domain/usecases/bulk_update_status.dart';
import 'package:factory_management/features/products/presentation/bloc/product_bloc.dart';

// Inventory
import 'package:factory_management/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:factory_management/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:factory_management/features/inventory/domain/usecases/add_stock.dart';
import 'package:factory_management/features/inventory/domain/usecases/adjust_stock.dart';
import 'package:factory_management/features/inventory/domain/usecases/get_inventory.dart';
import 'package:factory_management/features/inventory/domain/usecases/get_inventory_details.dart';
import 'package:factory_management/features/inventory/domain/usecases/get_stock_history.dart';
import 'package:factory_management/features/inventory/domain/usecases/remove_stock.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  final dio = Dio();
  dio.interceptors.add(NetworkInterceptor());
  sl.registerLazySingleton<Dio>(() => dio);
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<Dio>()));

  // Features - Navigation (Global)
  sl.registerLazySingleton<NavigationBloc>(() => NavigationBloc());

  // Features - Authentication
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(
        loginUseCase: sl<LoginUseCase>(),
        logoutUseCase: sl<LogoutUseCase>(),
        getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      )..add(AppStarted()));

  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<GetCurrentUserUseCase>(() => GetCurrentUserUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<CheckAuthUseCase>(() => CheckAuthUseCase(sl<AuthRepository>()));
  
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );
  
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Features - Website
  sl.registerFactory<WebsiteBloc>(() => WebsiteBloc(
        getFeaturedProductsUseCase: sl<GetFeaturedProductsUseCase>(),
        submitQuoteUseCase: sl<SubmitQuoteUseCase>(),
      ));
  sl.registerLazySingleton<GetFeaturedProductsUseCase>(() => GetFeaturedProductsUseCase(sl<WebsiteRepository>()));
  sl.registerLazySingleton<SubmitQuoteUseCase>(() => SubmitQuoteUseCase(sl<WebsiteRepository>()));
  
  sl.registerLazySingleton<WebsiteRepository>(
    () => WebsiteRepositoryImpl(remoteDataSource: sl<WebsiteRemoteDataSource>()),
  );
  
  sl.registerLazySingleton<WebsiteRemoteDataSource>(
    () => WebsiteRemoteDataSourceImpl(client: sl<ApiClient>()),
  );

  // Features - Dashboard
  sl.registerFactory<DashboardBloc>(() => DashboardBloc(
        getDashboardStatsUseCase: sl<GetDashboardStatsUseCase>(),
      ));
  sl.registerLazySingleton<GetDashboardStatsUseCase>(() => GetDashboardStatsUseCase(sl<DashboardRepository>()));
  
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl<DashboardRemoteDataSource>()),
  );
  
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(client: sl<ApiClient>()),
  );

  // Features - Categories
  sl.registerFactory<CategoryBloc>(() => CategoryBloc(
        getCategories: sl<GetCategories>(),
        getCategory: sl<GetCategory>(),
        createCategory: sl<CreateCategory>(),
        updateCategory: sl<UpdateCategory>(),
        deleteCategory: sl<DeleteCategory>(),
        toggleCategoryStatus: sl<ToggleCategoryStatus>(),
        reorderCategories: sl<ReorderCategories>(),
      ));
  sl.registerLazySingleton<GetCategories>(() => GetCategories(sl<CategoryRepository>()));
  sl.registerLazySingleton<GetCategory>(() => GetCategory(sl<CategoryRepository>()));
  sl.registerLazySingleton<CreateCategory>(() => CreateCategory(sl<CategoryRepository>()));
  sl.registerLazySingleton<UpdateCategory>(() => UpdateCategory(sl<CategoryRepository>()));
  sl.registerLazySingleton<DeleteCategory>(() => DeleteCategory(sl<CategoryRepository>()));
  sl.registerLazySingleton<ToggleCategoryStatus>(() => ToggleCategoryStatus(sl<CategoryRepository>()));
  sl.registerLazySingleton<ReorderCategories>(() => ReorderCategories(sl<CategoryRepository>()));
  
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(remoteDataSource: sl<CategoryRemoteDataSource>()),
  );
  
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(),
  );

  // Features - Products
  sl.registerFactory<ProductBloc>(() => ProductBloc(
        getProducts: sl<GetProducts>(),
        getProduct: sl<GetProduct>(),
        createProduct: sl<CreateProduct>(),
        updateProduct: sl<UpdateProduct>(),
        deleteProduct: sl<DeleteProduct>(),
        repository: sl<ProductRepository>(),
      ));
  sl.registerLazySingleton<GetProducts>(() => GetProducts(sl<ProductRepository>()));
  sl.registerLazySingleton<GetProduct>(() => GetProduct(sl<ProductRepository>()));
  sl.registerLazySingleton<CreateProduct>(() => CreateProduct(sl<ProductRepository>()));
  sl.registerLazySingleton<UpdateProduct>(() => UpdateProduct(sl<ProductRepository>()));
  sl.registerLazySingleton<DeleteProduct>(() => DeleteProduct(sl<ProductRepository>()));
  sl.registerLazySingleton<BulkDeleteProducts>(() => BulkDeleteProducts(sl<ProductRepository>()));
  sl.registerLazySingleton<BulkUpdateStatus>(() => BulkUpdateStatus(sl<ProductRepository>()));
  
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl<ProductRemoteDataSource>()),
  );
  
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(),
  );

  // Features - Inventory
  sl.registerFactory<InventoryBloc>(() => InventoryBloc(
        getInventory: sl<GetInventory>(),
        getInventoryDetails: sl<GetInventoryDetails>(),
        addStock: sl<AddStock>(),
        removeStock: sl<RemoveStock>(),
        adjustStock: sl<AdjustStock>(),
        getStockHistory: sl<GetStockHistory>(),
      ));
  sl.registerLazySingleton<GetInventory>(() => GetInventory(sl<InventoryRepository>()));
  sl.registerLazySingleton<GetInventoryDetails>(() => GetInventoryDetails(sl<InventoryRepository>()));
  sl.registerLazySingleton<AddStock>(() => AddStock(sl<InventoryRepository>()));
  sl.registerLazySingleton<RemoveStock>(() => RemoveStock(sl<InventoryRepository>()));
  sl.registerLazySingleton<AdjustStock>(() => AdjustStock(sl<InventoryRepository>()));
  sl.registerLazySingleton<GetStockHistory>(() => GetStockHistory(sl<InventoryRepository>()));
  
  sl.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(),
  );
}
