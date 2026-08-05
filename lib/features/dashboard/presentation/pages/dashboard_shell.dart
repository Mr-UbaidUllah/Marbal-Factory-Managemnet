import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/features/dashboard/presentation/bloc/navigation_bloc.dart';
import 'package:factory_management/features/dashboard/presentation/widgets/sidebar.dart';
import 'package:factory_management/features/dashboard/presentation/widgets/top_app_bar.dart';

class DashboardShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1100;

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          drawer: !isDesktop ? const Drawer(width: 260, child: Sidebar()) : null,
          body: Row(
            children: [
              if (isDesktop) const Sidebar(),
              Expanded(
                child: Column(
                  children: [
                    const TopAppBar(),
                    _buildBreadcrumbs(context, state),
                    Expanded(
                      child: navigationShell,
                    ),
                    _buildFooter(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBreadcrumbs(BuildContext context, NavigationState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Row(
        children: state.breadcrumbs.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          final isLast = index == state.breadcrumbs.length - 1;

          return Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isLast ? AppColors.textPrimary : AppColors.textSecondary,
                  fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (!isLast)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.chevron_right, size: 16, color: AppColors.textSecondary),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border.withOpacity(0.5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '© 2024 Alam Marble & Granite Factory. All rights reserved.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          Row(
            children: [
              _buildFooterLink('Privacy Policy'),
              const SizedBox(width: 16),
              _buildFooterLink('Terms of Service'),
              const SizedBox(width: 16),
              _buildFooterLink('Support'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String label) {
    return InkWell(
      onTap: () {},
      child: Text(
        label,
        style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
