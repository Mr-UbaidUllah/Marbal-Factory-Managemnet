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

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  final dio = Dio();
  dio.interceptors.add(NetworkInterceptor());
  sl.registerLazySingleton<Dio>(() => dio);
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<Dio>()));

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
}
