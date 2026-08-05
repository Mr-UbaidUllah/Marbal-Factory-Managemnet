import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/core/router/route_paths.dart';
import 'package:factory_management/features/authentication/domain/entities/user_entity.dart';
import 'package:factory_management/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:factory_management/features/dashboard/presentation/bloc/navigation_bloc.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, navState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            final userRole = authState is Authenticated ? authState.user.role : UserRole.customer;
            final isCollapsed = navState.isSidebarCollapsed;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isCollapsed ? 80 : 260,
              decoration: BoxDecoration(
                color: AppColors.darkGray,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(5, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildLogo(isCollapsed),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _buildNavList(context, userRole, isCollapsed),
                  ),
                  _buildCollapseButton(context, isCollapsed),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLogo(bool isCollapsed) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Row(
        mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.diamond, color: Colors.white, size: 24),
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ALAM MARBLE',
                    style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Factory Admin',
                    style: AppTextStyles.label.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavList(BuildContext context, UserRole role, bool isCollapsed) {
    final items = _getSidebarItems(role);
    final currentPath = GoRouterState.of(context).uri.path;

    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = currentPath == item.path || (item.path == RoutePaths.dashboard && currentPath == '${RoutePaths.dashboard}/${RoutePaths.dashboardOverview}');

        return _buildNavItem(context, item, isSelected, isCollapsed);
      },
    );
  }

  Widget _buildNavItem(BuildContext context, SidebarItem item, bool isSelected, bool isCollapsed) {
    final widget = Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          if (item.label == 'Logout') {
            context.read<AuthBloc>().add(LogoutRequested());
          } else {
            context.go(item.path);
            context.read<NavigationBloc>().add(UpdateBreadcrumbsEvent([item.label]));
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 0 : 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: AppColors.primary.withValues(alpha: 0.2)) : null,
          ),
          child: Row(
            mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                item.icon,
                size: 20,
                color: isSelected ? AppColors.primaryLight : Colors.white60,
              ),
              if (!isCollapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected ? Colors.white : Colors.white60,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (isCollapsed) {
      return Tooltip(
        message: item.label,
        child: widget,
      );
    }
    return widget;
  }

  Widget _buildCollapseButton(BuildContext context, bool isCollapsed) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: IconButton(
        onPressed: () => context.read<NavigationBloc>().add(ToggleSidebarEvent()),
        icon: Icon(
          isCollapsed ? Icons.arrow_right_alt_outlined : Icons.arrow_right_alt,
          color: Colors.white60,
        ),
      ),
    );
  }

  List<SidebarItem> _getSidebarItems(UserRole role) {
    final allItems = [
      SidebarItem(icon: Icons.dashboard, label: 'Dashboard', path: RoutePaths.dashboard, roles: [UserRole.owner, UserRole.admin, UserRole.staff]),
      SidebarItem(icon: Icons.production_quantity_limits, label: 'Products', path: '${RoutePaths.dashboard}/${RoutePaths.dashboardProducts}', roles: [UserRole.owner, UserRole.admin, UserRole.staff]),
      SidebarItem(icon: Icons.menu, label: 'Categories', path: '${RoutePaths.dashboard}/${RoutePaths.dashboardCategories}', roles: [UserRole.owner, UserRole.admin]),
      SidebarItem(icon: Icons.inventory, label: 'Inventory', path: '${RoutePaths.dashboard}/${RoutePaths.inventory}', roles: [UserRole.owner, UserRole.admin, UserRole.staff]),
      SidebarItem(icon: Icons.request_page, label: 'Quotations', path: '${RoutePaths.dashboard}/${RoutePaths.quotations}', roles: [UserRole.owner, UserRole.staff]),
      SidebarItem(icon: Icons.person, label: 'Customers', path: '${RoutePaths.dashboard}/${RoutePaths.customers}', roles: [UserRole.owner, UserRole.admin]),
      SidebarItem(icon: Icons.shopping_cart, label: 'Orders', path: '${RoutePaths.dashboard}/${RoutePaths.orders}', roles: [UserRole.owner, UserRole.admin]),
      SidebarItem(icon: Icons.supervised_user_circle_rounded, label: 'Employees', path: '${RoutePaths.dashboard}/${RoutePaths.employees}', roles: [UserRole.owner]),
      SidebarItem(icon: Icons.bar_chart, label: 'Analytics', path: '${RoutePaths.dashboard}/${RoutePaths.analytics}', roles: [UserRole.owner, UserRole.admin]),
      SidebarItem(icon: Icons.report, label: 'Reports', path: '${RoutePaths.dashboard}/${RoutePaths.reports}', roles: [UserRole.owner, UserRole.admin]),
      SidebarItem(icon: Icons.notification_add_outlined, label: 'Notifications', path: '${RoutePaths.dashboard}/${RoutePaths.notifications}', roles: [UserRole.owner, UserRole.admin, UserRole.staff]),
      SidebarItem(icon: Icons.settings, label: 'Settings', path: '${RoutePaths.dashboard}/${RoutePaths.settings}', roles: [UserRole.owner]),
      SidebarItem(icon: Icons.account_circle, label: 'Profile', path: '${RoutePaths.dashboard}/${RoutePaths.profile}', roles: [UserRole.owner, UserRole.admin, UserRole.staff]),
      SidebarItem(icon: Icons.logout, label: 'Logout', path: RoutePaths.login, roles: [UserRole.owner, UserRole.admin, UserRole.staff]),
    ];

    return allItems.where((item) => item.roles.contains(role)).toList();
  }
}

class SidebarItem {
  final IconData icon;
  final String label;
  final String path;
  final List<UserRole> roles;

  SidebarItem({
    required this.icon,
    required this.label,
    required this.path,
    required this.roles,
  });
}
