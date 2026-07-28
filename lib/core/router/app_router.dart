import 'dart:async';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/core/router/route_names.dart';
import 'package:factory_management/core/router/route_paths.dart';
import 'package:factory_management/features/authentication/domain/entities/user_entity.dart';
import 'package:factory_management/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:factory_management/features/authentication/presentation/pages/login_page.dart';
import 'package:factory_management/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:factory_management/features/website/presentation/pages/website_home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.home,
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(sl<AuthBloc>().stream),
    redirect: (context, state) {
      final authState = sl<AuthBloc>().state;
      final bool loggingIn = state.uri.path == RoutePaths.login;
      final bool isPublicRoute = state.uri.path == RoutePaths.home || loggingIn;

      if (authState is Unauthenticated || authState is AuthInitial) {
        if (!isPublicRoute) {
          return RoutePaths.login;
        }
      }

      if (authState is Authenticated) {
        if (loggingIn) {
          return _getHomeRouteForRole(authState.user.role);
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const WebsiteHomePage(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.dashboard,
        name: RouteNames.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('No route defined for ${state.uri}'),
      ),
    ),
  );

  static String _getHomeRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.owner:
      case UserRole.admin:
      case UserRole.staff:
        return RoutePaths.dashboard;
      case UserRole.customer:
        return RoutePaths.home;
    }
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
