import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:factory_management/core/theme/app_theme.dart';
import 'package:factory_management/core/router/app_router.dart';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:factory_management/features/dashboard/presentation/bloc/navigation_bloc.dart';
import 'package:factory_management/features/products/presentation/bloc/product_bloc.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_bloc.dart';
import 'package:factory_management/features/quotations/presentation/bloc/quote_bloc.dart';
import 'package:factory_management/features/quotations/presentation/bloc/quote_request_bloc.dart';
import 'package:factory_management/features/orders/presentation/bloc/order_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>(),
        ),
        BlocProvider<NavigationBloc>(
          create: (context) => sl<NavigationBloc>(),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => sl<ProductBloc>(),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => sl<CategoryBloc>(),
        ),
        BlocProvider<QuoteBloc>(
          create: (context) => sl<QuoteBloc>(),
        ),
        BlocProvider<QuoteRequestBloc>(
          create: (context) => QuoteRequestBloc(),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => sl<OrderBloc>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(1920, 1080),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            title: 'Alam Marble & Granite Factory',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
