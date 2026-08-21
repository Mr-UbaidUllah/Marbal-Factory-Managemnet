import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/core/router/route_names.dart';
import 'package:factory_management/core/router/route_paths.dart';
import 'package:factory_management/features/authentication/domain/entities/user_entity.dart';
import 'package:factory_management/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:factory_management/features/authentication/presentation/pages/login_page.dart';
import 'package:factory_management/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:factory_management/features/dashboard/presentation/pages/dashboard_shell.dart';
import 'package:factory_management/features/dashboard/presentation/pages/placeholder_pages.dart' hide CategoriesPage, InventoryPage;
import 'package:factory_management/features/products/presentation/pages/products_page.dart';
import 'package:factory_management/features/products/presentation/pages/product_details_page.dart';
import 'package:factory_management/features/products/presentation/pages/product_form_page.dart';
import 'package:factory_management/features/categories/presentation/pages/categories_page.dart';
import 'package:factory_management/features/categories/presentation/pages/category_form_page.dart';
import 'package:factory_management/features/website/presentation/pages/website_home_page.dart';
import 'package:factory_management/features/website/presentation/pages/website_products_page.dart';
import 'package:factory_management/features/website/presentation/pages/website_product_details_page.dart';
import 'package:factory_management/features/website/presentation/pages/website_categories_page.dart';
import 'package:factory_management/features/website/presentation/pages/website_category_details_page.dart';
import 'package:factory_management/features/website/presentation/pages/website_projects_page.dart';
import 'package:factory_management/features/website/presentation/pages/website_project_details_page.dart';
import 'package:factory_management/features/quotations/presentation/pages/quotations_page.dart' hide QuotationsPage;
import 'package:factory_management/features/quotations/presentation/pages/quote_details_page.dart';
import 'package:factory_management/features/quotations/presentation/pages/quote_response_page.dart';
import 'package:factory_management/features/quotations/presentation/pages/quote_request_page.dart';
import 'package:factory_management/features/orders/presentation/pages/orders_page.dart' hide OrdersPage;
import 'package:factory_management/features/orders/presentation/pages/order_details_page.dart';
import 'package:factory_management/features/orders/presentation/pages/order_invoice_page.dart';
import 'package:factory_management/features/orders/presentation/pages/order_form_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.home,
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(sl<AuthBloc>().stream),
    redirect: (context, state) {
      final authState = sl<AuthBloc>().state;
      final bool loggingIn = state.uri.path == RoutePaths.login;
      
      final bool isPublicRoute = state.uri.path == RoutePaths.home || 
                                 state.uri.path == RoutePaths.login ||
                                 state.uri.path == RoutePaths.products ||
                                 state.uri.path.startsWith('/products/') ||
                                 state.uri.path == RoutePaths.categories ||
                                 state.uri.path.startsWith('/categories/') ||
                                 state.uri.path == RoutePaths.projects ||
                                 state.uri.path.startsWith('/projects/') ||
                                 state.uri.path == RoutePaths.quoteRequest ||
                                 state.uri.path.startsWith('/quotes/') ||
                                 state.uri.path == RoutePaths.about ||
                                 state.uri.path == RoutePaths.contact;

      if (authState is Unauthenticated || authState is AuthInitial) {
        if (!isPublicRoute && state.uri.path.startsWith(RoutePaths.dashboard)) {
             return RoutePaths.login;
        }
      }

      if (authState is Authenticated) {
        if (loggingIn) {
          return _getHomeRouteForRole(authState.user.role);
        }
        
        if (state.uri.path.startsWith(RoutePaths.dashboard)) {
          if (!_hasAccess(authState.user.role, state.uri.path)) {
             return RoutePaths.dashboard;
          }
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
        path: RoutePaths.products,
        name: RouteNames.customerProducts,
        builder: (context, state) {
          final categoryId = state.uri.queryParameters['category'];
          return WebsiteProductsPage(initialCategoryId: categoryId);
        },
      ),
      GoRoute(
        path: RoutePaths.productDetails,
        name: RouteNames.productDetails,
        builder: (context, state) => WebsiteProductDetailsPage(productId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RoutePaths.categories,
        name: RouteNames.customerCategories,
        builder: (context, state) => const WebsiteCategoriesPage(),
      ),
      GoRoute(
        path: RoutePaths.categoryDetails,
        builder: (context, state) => WebsiteCategoryDetailsPage(categoryId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RoutePaths.projects,
        name: RouteNames.projects,
        builder: (context, state) => const WebsiteProjectsPage(),
      ),
      GoRoute(
        path: RoutePaths.projectDetails,
        name: RouteNames.projectDetails,
        builder: (context, state) => WebsiteProjectDetailsPage(projectId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RoutePaths.quoteRequest,
        name: RouteNames.quoteRequest,
        builder: (context, state) {
          final productId = state.uri.queryParameters['productId'];
          return QuoteRequestPage(productId: productId);
        },
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.publicQuoteDetails,
        builder: (context, state) => QuoteDetailsPage(quoteId: state.pathParameters['id']!),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return DashboardShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.dashboard,
                name: RouteNames.dashboardOverview,
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${RoutePaths.dashboard}/${RoutePaths.dashboardProducts}',
                name: RouteNames.dashboardProducts,
                builder: (context, state) => const ProductsPage(),
                routes: [
                  GoRoute(
                    path: RoutePaths.addProduct,
                    builder: (context, state) => const ProductFormPage(),
                  ),
                  GoRoute(
                    path: RoutePaths.editProduct,
                    builder: (context, state) => ProductFormPage(productId: state.pathParameters['id']),
                  ),
                  GoRoute(
                    path: RoutePaths.dashboardProductDetails,
                    builder: (context, state) => ProductDetailsPage(productId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${RoutePaths.dashboard}/${RoutePaths.dashboardCategories}',
                name: RouteNames.dashboardCategories,
                builder: (context, state) => const CategoriesPage(),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => const CategoryFormPage(),
                  ),
                  GoRoute(
                    path: 'edit/:id',
                    builder: (context, state) => CategoryFormPage(categoryId: state.pathParameters['id']),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${RoutePaths.dashboard}/${RoutePaths.quotations}',
                name: RouteNames.quotations,
                builder: (context, state) => const QuotationsPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => QuoteDetailsPage(quoteId: state.pathParameters['id']!),
                  ),
                  GoRoute(
                    path: ':id/respond',
                    builder: (context, state) => QuoteResponsePage(quoteId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${RoutePaths.dashboard}/${RoutePaths.customers}',
                name: RouteNames.customers,
                builder: (context, state) => const CustomersPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${RoutePaths.dashboard}/${RoutePaths.orders}',
                name: RouteNames.orders,
                builder: (context, state) => const OrdersPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => OrderDetailsPage(orderId: state.pathParameters['id']!),
                  ),
                  GoRoute(
                    path: ':id/edit',
                    builder: (context, state) => OrderFormPage(orderId: state.pathParameters['id']!),
                  ),
                  GoRoute(
                    path: ':id/invoice',
                    builder: (context, state) => OrderInvoicePage(orderId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${RoutePaths.dashboard}/${RoutePaths.employees}',
                name: RouteNames.employees,
                builder: (context, state) => const EmployeesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${RoutePaths.dashboard}/${RoutePaths.analytics}',
                name: RouteNames.analytics,
                builder: (context, state) => const AnalyticsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${RoutePaths.dashboard}/${RoutePaths.reports}',
                name: RouteNames.reports,
                builder: (context, state) => const ReportsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${RoutePaths.dashboard}/${RoutePaths.notifications}',
                name: RouteNames.notifications,
                builder: (context, state) => const NotificationsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${RoutePaths.dashboard}/${RoutePaths.settings}',
                name: RouteNames.settings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${RoutePaths.dashboard}/${RoutePaths.profile}',
                name: RouteNames.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('404 - Page Not Found', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('The route ${state.uri} does not exist.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
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

  static bool _hasAccess(UserRole role, String path) {
    if (role == UserRole.owner) return true;
    
    if (role == UserRole.admin) {
      final allowed = [
        RoutePaths.dashboard,
        '${RoutePaths.dashboard}/${RoutePaths.dashboardProducts}',
        '${RoutePaths.dashboard}/${RoutePaths.dashboardCategories}',
        '${RoutePaths.dashboard}/${RoutePaths.inventory}',
        '${RoutePaths.dashboard}/${RoutePaths.quotations}',
        '${RoutePaths.dashboard}/${RoutePaths.customers}',
        '${RoutePaths.dashboard}/${RoutePaths.orders}',
        '${RoutePaths.dashboard}/${RoutePaths.reports}',
        '${RoutePaths.dashboard}/${RoutePaths.analytics}',
        '${RoutePaths.dashboard}/${RoutePaths.notifications}',
        '${RoutePaths.dashboard}/${RoutePaths.profile}',
      ];
      return allowed.any((p) => path.startsWith(p));
    }

    if (role == UserRole.staff) {
      final allowed = [
        RoutePaths.dashboard,
        '${RoutePaths.dashboard}/${RoutePaths.dashboardProducts}',
        '${RoutePaths.dashboard}/${RoutePaths.inventory}',
        '${RoutePaths.dashboard}/${RoutePaths.quotations}',
        '${RoutePaths.dashboard}/${RoutePaths.orders}',
        '${RoutePaths.dashboard}/${RoutePaths.notifications}',
        '${RoutePaths.dashboard}/${RoutePaths.profile}',
      ];
      return allowed.any((p) => path.startsWith(p));
    }

    return false;
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
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
