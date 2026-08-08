import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/categories/domain/entities/category.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_bloc.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_event.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_state.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CategoryListTable extends StatelessWidget {
  final List<Category> categories;

  const CategoryListTable({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppColors.surface),
              dataRowMaxHeight: 70,
              columnSpacing: 24,
              columns: [
                DataColumn(label: Text('Category', style: AppTextStyles.label)),
                DataColumn(label: Text('Description', style: AppTextStyles.label)),
                DataColumn(label: Text('Products', style: AppTextStyles.label)),
                DataColumn(label: Text('Status', style: AppTextStyles.label)),
                DataColumn(label: Text('Sort Order', style: AppTextStyles.label)),
                DataColumn(label: Text('Created At', style: AppTextStyles.label)),
                DataColumn(label: Text('Actions', style: AppTextStyles.label)),
              ],
              rows: categories.map((category) => _buildRow(context, category)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, Category category) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  image: category.image != null
                      ? DecorationImage(
                          image: NetworkImage(category.image!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: category.image == null
                    ? const Center(child: FaIcon(FontAwesomeIcons.layerGroup, size: 16, color: AppColors.textSecondary))
                    : null,
              ),
              const SizedBox(width: 12),
              Text(category.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        DataCell(
          SizedBox(
            width: 200,
            child: Text(
              category.description ?? '-',
              style: AppTextStyles.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${category.productCount} Products',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataCell(_buildStatusBadge(category.active)),
        DataCell(
          Row(
            children: [
              Text('${category.sortOrder}', style: AppTextStyles.bodyMedium),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      // Move Up logic (simplified for reorder event)
                    },
                    child: const FaIcon(FontAwesomeIcons.chevronUp, size: 10),
                  ),
                  InkWell(
                    onTap: () {
                      // Move Down logic
                    },
                    child: const FaIcon(FontAwesomeIcons.chevronDown, size: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
        DataCell(Text(DateFormat('MMM dd, yyyy').format(category.createdAt), style: AppTextStyles.bodySmall)),
        DataCell(
          Row(
            children: [
              IconButton(
                tooltip: 'Edit',
                icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 16, color: AppColors.textSecondary),
                onPressed: () => context.push('/dashboard/categories/edit/${category.id}'),
              ),
              IconButton(
                tooltip: category.active ? 'Deactivate' : 'Activate',
                icon: FaIcon(
                  category.active ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => context.read<CategoryBloc>().add(ToggleCategoryStatusEvent(category.id, !category.active)),
              ),
              IconButton(
                tooltip: 'Delete',
                icon: const FaIcon(FontAwesomeIcons.trashCan, size: 16, color: AppColors.error),
                onPressed: () => _showDeleteDialog(context, category),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (active ? Colors.green : Colors.grey).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        active ? 'ACTIVE' : 'INACTIVE',
        style: AppTextStyles.bodySmall.copyWith(
          color: active ? Colors.green : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Category category) {
    final bloc = context.read<CategoryBloc>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
          category.productCount > 0
              ? 'This category contains ${category.productCount} products. Move or reassign these products before deleting the category.'
              : 'Are you sure you want to delete "${category.name}"?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          if (category.productCount == 0)
            ElevatedButton(
              onPressed: () {
                bloc.add(DeleteCategoryEvent(category.id));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
              child: const Text('Delete'),
            ),
        ],
      ),
    );
  }
}
