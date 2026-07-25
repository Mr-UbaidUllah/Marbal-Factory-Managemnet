import 'package:flutter/material.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: Column(
              children: [
                const TopAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeSection(),
                        const SizedBox(height: 32),
                        const StatisticsGrid(),
                        const SizedBox(height: 32),
                        const AnalyticsSection(),
                        const SizedBox(height: 32),
                        const TopSellingProducts(),
                        const SizedBox(height: 32),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 1100) {
                              return const Column(
                                children: [
                                  RecentOrdersTable(),
                                  SizedBox(height: 32),
                                  RecentQuoteRequests(),
                                  SizedBox(height: 32),
                                  QuickInventory(),
                                ],
                              );
                            }
                            return const Row(
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
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 1100) {
                              return const Column(
                                children: [
                                  LowStockAlerts(),
                                  SizedBox(height: 32),
                                  ActivityCalendar(),
                                  SizedBox(height: 32),
                                  RightSidebarWidgets(),
                                ],
                              );
                            }
                            return const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: LowStockAlerts()),
                                SizedBox(width: 32),
                                Expanded(child: ActivityCalendar()),
                                SizedBox(width: 32),
                                Expanded(child: RightSidebarWidgets()),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
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
                      Text('Welcome back, Admin', style: AppTextStyles.h1),
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
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildQuickActions(),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildQuickAction('Add Product', Icons.add,),
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
          const Row(
            children: [
              Icon(Icons.wb_sunny_outlined, color: AppColors.gold, size: 32),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('32°C Sunny', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text('Sharjah Industrial Area', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ]),
      ],
    );
  }

  Widget _buildWidgetCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
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
        children: [
          Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
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
