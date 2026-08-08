import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/products/presentation/bloc/product_bloc.dart';
import 'package:factory_management/features/products/presentation/bloc/product_event.dart';
import 'package:factory_management/features/products/presentation/bloc/product_state.dart';

class ProductFilterSidebar extends StatefulWidget {
  final bool isMobile;

  const ProductFilterSidebar({super.key, this.isMobile = false});

  @override
  State<ProductFilterSidebar> createState() => _ProductFilterSidebarState();
}

class _ProductFilterSidebarState extends State<ProductFilterSidebar> {
  String? _selectedCategory;
  String? _selectedMaterial;
  String? _selectedFinish;
  String? _selectedColor;
  String? _selectedOrigin;
  bool? _isFeatured;
  bool? _isActive;

  final List<String> _categories = ['Marble', 'Granite', 'Onyx', 'Travertine', 'Quartz'];
  final List<String> _materials = ['Natural Stone', 'Engineered Stone', 'Slab', 'Tile'];
  final List<String> _finishes = ['Polished', 'Honed', 'Brushed', 'Leathered', 'Flamed'];
  final List<String> _colors = ['White', 'Black', 'Beige', 'Grey', 'Red', 'Green', 'Blue'];
  final List<String> _origins = ['Italy', 'India', 'Spain', 'Turkey', 'Iran', 'Brazil', 'China'];

  @override
  void initState() {
    super.initState();
    final state = context.read<ProductBloc>().state;
    _selectedCategory = state.categoryId;
    _selectedMaterial = state.materialType;
    _selectedFinish = state.finish;
    _selectedColor = state.color;
    _selectedOrigin = state.originCountry;
    _isFeatured = state.featured;
    _isActive = state.active;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isMobile) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filters', style: AppTextStyles.h3),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.xmark, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Flexible(child: SingleChildScrollView(child: _buildFilterContent())),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      );
    }

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.filter, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('Filters', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(child: SingleChildScrollView(child: _buildFilterContent())),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildFilterContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Category'),
        _buildDropdown(
          value: _selectedCategory,
          items: _categories,
          hint: 'All Categories',
          onChanged: (val) => setState(() => _selectedCategory = val),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('Material Type'),
        _buildDropdown(
          value: _selectedMaterial,
          items: _materials,
          hint: 'All Materials',
          onChanged: (val) => setState(() => _selectedMaterial = val),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('Finish'),
        _buildDropdown(
          value: _selectedFinish,
          items: _finishes,
          hint: 'All Finishes',
          onChanged: (val) => setState(() => _selectedFinish = val),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('Color'),
        _buildDropdown(
          value: _selectedColor,
          items: _colors,
          hint: 'All Colors',
          onChanged: (val) => setState(() => _selectedColor = val),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('Origin'),
        _buildDropdown(
          value: _selectedOrigin,
          items: _origins,
          hint: 'All Countries',
          onChanged: (val) => setState(() => _selectedOrigin = val),
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 12),
        _buildSectionTitle('Status'),
        SwitchListTile(
          title: Text('Featured Products', style: AppTextStyles.bodyMedium),
          value: _isFeatured ?? false,
          activeColor: AppColors.primary,
          onChanged: (val) => setState(() => _isFeatured = val),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: Text('Active Only', style: AppTextStyles.bodyMedium),
          value: _isActive ?? true,
          activeColor: AppColors.primary,
          onChanged: (val) => setState(() => _isActive = val),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: AppTextStyles.bodySmall),
          isExpanded: true,
          items: [
            DropdownMenuItem<String>(value: null, child: Text(hint, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))),
            ...items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: AppTextStyles.bodyMedium),
              );
            }),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(ApplyFiltersEvent(
                categoryId: _selectedCategory,
                materialType: _selectedMaterial,
                finish: _selectedFinish,
                color: _selectedColor,
                originCountry: _selectedOrigin,
                featured: _isFeatured,
                active: _isActive,
              ));
              if (widget.isMobile) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text('Apply Filters'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              setState(() {
                _selectedCategory = null;
                _selectedMaterial = null;
                _selectedFinish = null;
                _selectedColor = null;
                _selectedOrigin = null;
                _isFeatured = null;
                _isActive = null;
              });
              context.read<ProductBloc>().add(const ApplyFiltersEvent());
              if (widget.isMobile) Navigator.pop(context);
            },
            child: Text('Reset All', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ),
        ),
      ],
    );
  }
}
