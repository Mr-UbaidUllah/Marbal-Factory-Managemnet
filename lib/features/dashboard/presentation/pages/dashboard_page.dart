import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:factory_management/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:factory_management/features/dashboard/presentation/widgets/sidebar.dart';
import 'package:factory_management/features/dashboard/presentation/widgets/top_app_bar.dart';
import 'package:factory_management/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:factory_management/features/dashboard/presentation/widgets/analytics_section.dart';
import 'package:factory_management/features/dashboard/presentation/widgets/recent_orders_table.dart';
import 'package:factory_management/features/dashboard/presentation/widgets/top_selling_products.dart';
import 'package:factory_management/features/dashboard/presentation/widgets/low_stock_alerts.dart';
import 'package:factory_management/features/dashboard/presentation/widgets/recent_quote_requests.dart';
import 'package:factory_management/features/dashboard/presentation/widgets/quick_inventory.dart';
import 'package:factory_management/features/dashboard/presentation/widgets/activity_calendar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool showSidebar = screenWidth >= 1100;

    return BlocProvider(
      create: (context) => sl<DashboardBloc>()..add(GetDashboardStatsEvent()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        drawer: !showSidebar ? const Drawer(width: 260, child: Sidebar()) : null,
        body: Row(
          children: [
            if (showSidebar) const Sidebar(),
            Expanded(
              child: Column(
                children: [
                  const TopAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(screenWidth < 600 ? 16 : 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWelcomeSection(screenWidth),
                          const SizedBox(height: 32),
                          const StatisticsGrid(),
                          const SizedBox(height: 32),
                          const AnalyticsSection(),
                          const SizedBox(height: 32),
                          const TopSellingProducts(),
                          const SizedBox(height: 32),
                          
                          // Responsive Orders & Quotes Section
                          if (screenWidth < 1200) ...[
                            const RecentOrdersTable(),
                            const SizedBox(height: 32),
                            const RecentQuoteRequests(),
                            const SizedBox(height: 32),
                            const QuickInventory(),
                          ] else ...[
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 2, child: RecentOrdersTable()),
                                SizedBox(width: 32),
                                Expanded(
                                  child: Column(
                                    children: [
                                      RecentQuoteRequests(),
                                      SizedBox(height: 32),
                                      QuickInventory(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                          
                          const SizedBox(height: 32),
                          
                          // Responsive Alerts & Activity Section
                          if (screenWidth < 1200) ...[
                            const LowStockAlerts(),
                            const SizedBox(height: 32),
                            const ActivityCalendar(),
                            const SizedBox(height: 32),
                            const RightSidebarWidgets(),
                          ] else ...[
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: LowStockAlerts()),
                                SizedBox(width: 32),
                                Expanded(child: ActivityCalendar()),
                                SizedBox(width: 32),
                                Expanded(child: RightSidebarWidgets()),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(double screenWidth) {
    final isMobile = screenWidth < 900;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome back, Admin', 
                    style: AppTextStyles.h1.copyWith(
                      fontSize: screenWidth < 600 ? 24 : 32
                    )
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Thursday, 24 October 2024',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            if (!isMobile) _buildQuickActions(),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildQuickActions(),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildQuickAction('Add Product', Icons.add),
        const SizedBox(width: 12),
        _buildQuickAction('Add Category', Icons.category_outlined, isPrimary: false),
        const SizedBox(width: 12),
        _buildQuickAction('Create Quote', Icons.request_quote_outlined, isPrimary: false),
      ],
    );
  }

  Widget _buildQuickAction(String label, IconData icon, {bool isPrimary = true}) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18, color: isPrimary ? Colors.white : AppColors.primary),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AppColors.primary : Colors.white,
        foregroundColor: isPrimary ? Colors.white : AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPrimary ? BorderSide.none : const BorderSide(color: AppColors.border),
        ),
        elevation: 0,
      ),
    );
  }
}

class RightSidebarWidgets extends StatelessWidget {
  const RightSidebarWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildWidgetCard('Recent Activity', [
          _buildActivityItem('John added new slab "Carrara"', '2 mins ago'),
          _buildActivityItem('Inventory check completed', '1 hour ago'),
          _buildActivityItem('Quote #124 approved', '3 hours ago'),
        ]),
        const SizedBox(height: 24),
        _buildWidgetCard('Weather', [
          Row(
            children: [
              const Icon(Icons.wb_sunny_outlined, color: AppColors.gold, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('32°C Sunny', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text('Sharjah Industrial Area', 
                      style: AppTextStyles.label.copyWith(fontSize: 12, color: AppColors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ],
    );
  }

  Widget _buildWidgetCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildActivityItem(String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6, 
            height: 6, 
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
                Text(time, style: AppTextStyles.label.copyWith(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
