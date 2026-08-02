import 'package:flutter/material.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/website/presentation/pages/website_home_page.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth < 1024;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(color: AppColors.border.withOpacity(0.5)),
        ),
      ),
      child: Row(
        children: [
          if (isTablet)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          if (!isMobile)
            Flexible(
              child: Text(
                "ALAM MARBLE & GRANITE",
                style: AppTextStyles.h1.copyWith(
                  color: const Color(0xFF005C55),
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth < 1200 ? 18 : 24,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          const SizedBox(width: 16),
          if (!isMobile)
            Expanded(
              flex: 2,
              child: _buildSearchField(),
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          const Spacer(),
          if (!isMobile) ...[
            _buildIconButton(Icons.notification_add_outlined, hasBadge: true),
            const SizedBox(width: 12),
            _buildIconButton(Icons.mail_outline),
            const SizedBox(width: 16),
          ],
          if (screenWidth > 1200) ...[
            _buildLanguageSelector(),
            const SizedBox(width: 16),
          ],
          if (!isMobile) ...[
            _buildActionButton(
              label: screenWidth < 1400 ? "Website" : "View Website",
              icon: Icons.public,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WebsiteHomePage()),
                );
              },
            ),
            const SizedBox(width: 16),
          ],
          _buildUserProfile(isMobile),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.textTertiary,
              size: 18,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 9),
          ),
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
      icon: Icon(icon, color: Colors.white, size: 16),
      label: Text(label, style: AppTextStyles.button.copyWith(fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {bool hasBadge = false}) {
    return Stack(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 22),
        if (hasBadge)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLanguageSelector() {
    return Row(
      children: [
        const Icon(Icons.language, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          "EN",
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildUserProfile(bool isMobile) {
    return Row(
      children: [
        if (!isMobile)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Admin',
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              Text('Super Admin', style: AppTextStyles.label.copyWith(fontSize: 11)),
            ],
          ),
        const SizedBox(width: 8),
        const CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.primaryLight,
          child: Text('A', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
