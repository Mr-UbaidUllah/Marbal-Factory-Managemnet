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
import 'package:factory_management/features/website/domain/usecases/get_projects_usecase.dart';
import 'package:factory_management/features/website/domain/usecases/get_project_by_id_usecase.dart';
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

// Quotations
import 'package:factory_management/features/quotations/data/repositories/quote_repository_impl.dart';
import 'package:factory_management/features/quotations/domain/repositories/quote_repository.dart';
import 'package:factory_management/features/quotations/domain/usecases/get_quotes.dart';
import 'package:factory_management/features/quotations/domain/usecases/get_quote_by_id.dart';
import 'package:factory_management/features/quotations/domain/usecases/create_quote.dart';
import 'package:factory_management/features/quotations/domain/usecases/update_quote.dart';
import 'package:factory_management/features/quotations/domain/usecases/submit_quote.dart';
import 'package:factory_management/features/quotations/domain/usecases/review_quote.dart';
import 'package:factory_management/features/quotations/domain/usecases/respond_to_quote.dart';
import 'package:factory_management/features/quotations/domain/usecases/accept_quote.dart';
import 'package:factory_management/features/quotations/domain/usecases/reject_quote.dart';
import 'package:factory_management/features/quotations/domain/usecases/cancel_quote.dart';
import 'package:factory_management/features/quotations/presentation/bloc/quote_bloc.dart';

// Orders
import 'package:factory_management/features/orders/data/repositories/order_repository_impl.dart';
import 'package:factory_management/features/orders/domain/repositories/order_repository.dart';
import 'package:factory_management/features/orders/domain/usecases/get_orders.dart';
import 'package:factory_management/features/orders/domain/usecases/get_order.dart';
import 'package:factory_management/features/orders/domain/usecases/create_order_from_quote.dart';
import 'package:factory_management/features/orders/domain/usecases/update_order.dart';
import 'package:factory_management/features/orders/domain/usecases/change_order_status.dart';
import 'package:factory_management/features/orders/domain/usecases/update_payment.dart';
import 'package:factory_management/features/orders/domain/usecases/cancel_order.dart';
import 'package:factory_management/features/orders/domain/usecases/get_order_status_history.dart';
import 'package:factory_management/features/orders/presentation/bloc/order_bloc.dart';


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
        getProjectsUseCase: sl<GetProjectsUseCase>(),
        getProjectByIdUseCase: sl<GetProjectByIdUseCase>(),
      ));
  sl.registerLazySingleton<GetFeaturedProductsUseCase>(() => GetFeaturedProductsUseCase(sl<WebsiteRepository>()));
  sl.registerLazySingleton<SubmitQuoteUseCase>(() => SubmitQuoteUseCase(sl<WebsiteRepository>()));
  sl.registerLazySingleton<GetProjectsUseCase>(() => GetProjectsUseCase(sl<WebsiteRepository>()));
  sl.registerLazySingleton<GetProjectByIdUseCase>(() => GetProjectByIdUseCase(sl<WebsiteRepository>()));
  
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

  // Features - Quotations
  sl.registerFactory<QuoteBloc>(() => QuoteBloc(
        getQuotes: sl<GetQuotes>(),
        getQuoteById: sl<GetQuoteById>(),
        createQuote: sl<CreateQuote>(),
        reviewQuote: sl<ReviewQuote>(),
        respondToQuote: sl<RespondToQuote>(),
        acceptQuote: sl<AcceptQuote>(),
        rejectQuote: sl<RejectQuote>(),
        cancelQuote: sl<CancelQuote>(),
      ));
  sl.registerLazySingleton<GetQuotes>(() => GetQuotes(sl<QuoteRepository>()));
  sl.registerLazySingleton<GetQuoteById>(() => GetQuoteById(sl<QuoteRepository>()));
  sl.registerLazySingleton<CreateQuote>(() => CreateQuote(sl<QuoteRepository>()));
  sl.registerLazySingleton<UpdateQuote>(() => UpdateQuote(sl<QuoteRepository>()));
  sl.registerLazySingleton<SubmitQuote>(() => SubmitQuote(sl<QuoteRepository>()));
  sl.registerLazySingleton<ReviewQuote>(() => ReviewQuote(sl<QuoteRepository>()));
  sl.registerLazySingleton<RespondToQuote>(() => RespondToQuote(sl<QuoteRepository>()));
  sl.registerLazySingleton<AcceptQuote>(() => AcceptQuote(sl<QuoteRepository>()));
  sl.registerLazySingleton<RejectQuote>(() => RejectQuote(sl<QuoteRepository>()));
  sl.registerLazySingleton<CancelQuote>(() => CancelQuote(sl<QuoteRepository>()));

  sl.registerLazySingleton<QuoteRepository>(
    () => QuoteRepositoryImpl(),
  );

  // Features - Orders
  sl.registerFactory<OrderBloc>(() => OrderBloc(
        getOrders: sl<GetOrders>(),
        getOrder: sl<GetOrder>(),
        createOrderFromQuote: sl<CreateOrderFromQuote>(),
        updateOrder: sl<UpdateOrder>(),
        changeOrderStatus: sl<ChangeOrderStatus>(),
        updatePayment: sl<UpdatePayment>(),
        cancelOrder: sl<CancelOrder>(),
        getOrderStatusHistory: sl<GetOrderStatusHistory>(),
      ));
  sl.registerLazySingleton<GetOrders>(() => GetOrders(sl<OrderRepository>()));
  sl.registerLazySingleton<GetOrder>(() => GetOrder(sl<OrderRepository>()));
  sl.registerLazySingleton<CreateOrderFromQuote>(() => CreateOrderFromQuote(sl<OrderRepository>()));
  sl.registerLazySingleton<UpdateOrder>(() => UpdateOrder(sl<OrderRepository>()));
  sl.registerLazySingleton<ChangeOrderStatus>(() => ChangeOrderStatus(sl<OrderRepository>()));
  sl.registerLazySingleton<UpdatePayment>(() => UpdatePayment(sl<OrderRepository>()));
  sl.registerLazySingleton<CancelOrder>(() => CancelOrder(sl<OrderRepository>()));
  sl.registerLazySingleton<GetOrderStatusHistory>(() => GetOrderStatusHistory(sl<OrderRepository>()));

  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(quoteRepository: sl<QuoteRepository>()),
  );
}
