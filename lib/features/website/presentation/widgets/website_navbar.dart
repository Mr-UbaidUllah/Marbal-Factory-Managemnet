import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/router/route_paths.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/authentication/presentation/bloc/auth_bloc.dart';

class WebsiteNavbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isScrolled;
  const WebsiteNavbar({super.key, required this.isScrolled});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 80,
      decoration: BoxDecoration(
        color: isScrolled ? Colors.white : Colors.transparent,
        boxShadow: isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                )
              ]
            : [],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        children: [
          // Logo
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => context.go(RoutePaths.home),
              child: Text(
                "ALAM MARBLE",
                style: AppTextStyles.h2.copyWith(
                  color: isScrolled ? AppColors.primary : Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          const Spacer(),
          // Nav Links
          _NavLink(title: "Home", isScrolled: isScrolled, isActive: true, onTap: () => context.go(RoutePaths.home)),
          _NavLink(title: "Products", isScrolled: isScrolled),
          _NavLink(title: "Categories", isScrolled: isScrolled),
          _NavLink(title: "Projects", isScrolled: isScrolled),
          _NavLink(title: "Gallery", isScrolled: isScrolled),
          _NavLink(title: "About Us", isScrolled: isScrolled),
          _NavLink(title: "Contact", isScrolled: isScrolled),
          
          // Login / Dashboard Link
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return _NavLink(
                  title: "Dashboard",
                  isScrolled: isScrolled,
                  onTap: () => context.go(RoutePaths.dashboard),
                );
              }
              return _NavLink(
                title: "Login",
                isScrolled: isScrolled,
                onTap: () => context.go(RoutePaths.login),
              );
            },
          ),
          
          const SizedBox(width: 40),
          // Actions
          Icon(Icons.search, color: isScrolled ? AppColors.textPrimary : Colors.white),
          const SizedBox(width: 20),
          Icon(Icons.favorite_border, color: isScrolled ? AppColors.textPrimary : Colors.white),
          const SizedBox(width: 30),
          // Request Quote Button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Request a Quote"),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _NavLink extends StatelessWidget {
  final String title;
  final bool isScrolled;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavLink({
    required this.title,
    required this.isScrolled,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isActive 
                  ? AppColors.gold 
                  : (isScrolled ? AppColors.textPrimary : Colors.white),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
