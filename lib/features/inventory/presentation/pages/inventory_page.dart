import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/inventory/domain/entities/inventory.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_event.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_state.dart';
import 'package:factory_management/features/inventory/presentation/widgets/inventory_list_table.dart';
import 'package:factory_management/features/inventory/presentation/widgets/inventory_stats_cards.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return BlocProvider(
      create: (context) => sl<InventoryBloc>()..add(const LoadInventory()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, isMobile),
              const SizedBox(height: 24),
              const InventoryStatsCards(),
              const SizedBox(height: 24),
              _buildActionBar(context, isMobile),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<InventoryBloc, InventoryState>(
                  builder: (context, state) {
                    if (state.status == InventoryStateStatus.loading && state.inventory.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.status == InventoryStateStatus.failure) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(FontAwesomeIcons.circleExclamation, size: 48, color: AppColors.error),
                            const SizedBox(height: 16),
                            Text(state.errorMessage ?? 'Error loading inventory', style: AppTextStyles.h3),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context.read<InventoryBloc>().add(const LoadInventory()),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (state.inventory.isEmpty && state.status == InventoryStateStatus.success) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(FontAwesomeIcons.boxesStacked, size: 45, color: AppColors.textSecondary),
                            const SizedBox(height: 16),
                            Text('No inventory items found', style: AppTextStyles.h3),
                            const SizedBox(height: 8),
                            Text('Try adjusting your filters or search query', style: AppTextStyles.bodyMedium),
                          ],
                        ),
                      );
                    }

                    return InventoryListTable(inventory: state.inventory);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Inventory Management', style: AppTextStyles.h1),
            const SizedBox(height: 4),
            Text('Monitor and manage factory stock levels', 
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)
            ),
          ],
        ),
        Row(
          children: [
            if (!isMobile)
              ElevatedButton.icon(
                onPressed: () => context.push('/dashboard/inventory/history'),
                icon: const FaIcon(FontAwesomeIcons.clockRotateLeft, size: 14),
                label: const Text('Stock History'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            const SizedBox(width: 12),
          ],
        ),
      ],
    );
  }

  Widget _buildActionBar(BuildContext context, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                fillColor: AppColors.surface,
                filled: true,
                hintText: 'Search inventory by product name or SKU...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                prefixIcon: const Center(
                  widthFactor: 1.0,
                  child: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 16),
                ),
                suffixIcon: _searchController.text.isNotEmpty 
                  ? IconButton(
                      icon: const FaIcon(FontAwesomeIcons.xmark, size: 14, color: AppColors.textSecondary,),
                      onPressed: () {
                        _searchController.clear();
                        context.read<InventoryBloc>().add(const SearchInventoryEvent(''));
                      },
                    )
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                context.read<InventoryBloc>().add(SearchInventoryEvent(value));
              },
            ),
          ),
          const SizedBox(width: 16),
          _buildFilterButton(context),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        return PopupMenuButton<InventoryStatus?>(
          initialValue: state.filterStatus,
          tooltip: 'Filter by stock status',
          onSelected: (value) {
            context.read<InventoryBloc>().add(FilterInventoryByStatus(value));
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: null, child: Text('All Status')),
            PopupMenuItem(value: InventoryStatus.inStock, child: Text('In Stock')),
            PopupMenuItem(value: InventoryStatus.lowStock, child: Text('Low Stock')),
            PopupMenuItem(value: InventoryStatus.outOfStock, child: Text('Out of Stock')),
            PopupMenuItem(value: InventoryStatus.overstocked, child: Text('Overstocked')),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const FaIcon(FontAwesomeIcons.filter, size: 14),
                const SizedBox(width: 8),
                Text(
                  state.filterStatus == null ? 'All Status' : state.filterStatus!.name, 
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(width: 8),
                const FaIcon(FontAwesomeIcons.chevronDown, size: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
