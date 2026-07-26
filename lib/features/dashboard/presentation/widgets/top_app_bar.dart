import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/website/presentation/pages/website_home_page.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(color: AppColors.border.withOpacity(0.5)),
        ),
      ),
      child: Row(
        children: [
          Text("ALAM MARBLE & GRANITE FACTORY",
            style: AppTextStyles.h1.copyWith(color: const Color(0xFF005C55), fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(width: 32),
          _buildSearchField(),
          const Spacer(),
          _buildIconButton(Icons.notification_add_outlined, hasBadge: true),
          const SizedBox(width: 16),
          _buildIconButton(Icons.mail_outline),
          const SizedBox(width: 24),
          _buildLanguageSelector(),
          const SizedBox(width: 16),
          _buildActionButton(
            label: "View Website",
            icon: HugeIcons.global,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WebsiteHomePage()),
              );
            },
          ),
          const SizedBox(width: 24),
          _buildUserProfile(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      width: 392,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textTertiary,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textTertiary,
            size: 20,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: HugeIcon(icon: icon, color: Colors.white, size: 18),
      label: Text(label, style: AppTextStyles.button),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {bool hasBadge = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Stack(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 24),
          if (hasBadge)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Row(
        children: [
          const Icon(
            Icons.language,
            size: 20,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text("EN", style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Admin User',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text('Super Admin', style: AppTextStyles.label),
          ],
        ),
        const SizedBox(width: 12),
        const CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primaryLight,
          child: Text(
            'A',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.keyboard_arrow_down,
          size: 16,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
