import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool isCollapsed = false;
  int selectedIndex = 0;

  final List<SidebarItem> items = [
    SidebarItem(icon: Icons.dashboard, label: 'Dashboard'),
    SidebarItem(icon: Icons.production_quantity_limits, label: 'Products'),
    SidebarItem(icon: Icons.menu, label: 'Categories'),
    SidebarItem(icon: Icons.inventory, label: 'Inventory'),
    SidebarItem(icon: Icons.shopping_cart, label: 'Orders'),
    SidebarItem(icon: Icons.request_page, label: 'Quote Requests'),
    SidebarItem(icon: Icons.person, label: 'Customers'),
    SidebarItem(icon: Icons.delivery_dining, label: 'Suppliers'),
    SidebarItem(icon: Icons.bar_chart, label: 'Analytics'),
    SidebarItem(icon: Icons.supervised_user_circle_rounded, label: 'Employees'),
    SidebarItem(icon: Icons.report, label: 'Reports'),
    SidebarItem(icon: Icons.notification_add_outlined, label: 'Notifications'),
    SidebarItem(icon: Icons.settings, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCollapsed ? 80 : 260,
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(5, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLogo(),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                return _buildNavItem(index);
              },
            ),
          ),
          _buildCollapseButton(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
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
            child: const Icon(
              Icons.diamond,
              color: Colors.white,
              size: 24,
            ),
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

  Widget _buildNavItem(int index) {
    final item = items[index];
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => setState(() => selectedIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 0 : 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: AppColors.primary.withOpacity(0.2)) : null,
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
  }

  Widget _buildCollapseButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: IconButton(
        onPressed: () => setState(() => isCollapsed = !isCollapsed),
        icon: Icon(
          isCollapsed ? Icons.arrow_right_alt_outlined : Icons.arrow_right_alt,
          color: Colors.white60,
        ),
      ),
    );
  }
}

class SidebarItem {
  final IconData icon;
  final String label;

  SidebarItem({required this.icon, required this.label});
}

