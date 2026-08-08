import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/categories/domain/entities/category.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_bloc.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_event.dart';
import 'package:factory_management/features/categories/presentation/bloc/category_state.dart';

class CategoryFormPage extends StatefulWidget {
  final String? categoryId;

  const CategoryFormPage({super.key, this.categoryId});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _slugController;
  late TextEditingController _sortOrderController;
  
  bool _isActive = true;
  String? _parentId;
  String? _imageUrl;
  
  bool get isEditing => widget.categoryId != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _slugController = TextEditingController();
    _sortOrderController = TextEditingController(text: '0');

    if (isEditing) {
      // Data will be populated via Bloc listener
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _slugController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }

  void _onNameChanged(String value) {
    if (!isEditing) {
      _slugController.text = value.toLowerCase().replaceAll(' ', '-').replaceAll(RegExp(r'[^a-z0-9-]'), '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = sl<CategoryBloc>();
        if (isEditing) {
          bloc.add(GetCategoryEvent(widget.categoryId!));
        }
        bloc.add(const LoadCategories(active: true)); // For parent category selection
        return bloc;
      },
      child: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (isEditing && state.selectedCategory != null && state.status == CategoryStatus.success && _nameController.text.isEmpty) {
            final category = state.selectedCategory!;
            _nameController.text = category.name;
            _descriptionController.text = category.description ?? '';
            _slugController.text = category.slug;
            _sortOrderController.text = category.sortOrder.toString();
            _isActive = category.active;
            _parentId = category.parentId;
            _imageUrl = category.image;
          }

          if (state.status == CategoryStatus.success && state.errorMessage == null && !state.status.name.contains('loading')) {
             // Success handling for create/update is usually handled by the BLoC emitting a specific state or we can check transition
          }
          
          if (state.status == CategoryStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'An error occurred'), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == CategoryStatus.loading || state.status == CategoryStatus.submitting;

          return Scaffold(
            backgroundColor: AppColors.surface,
            appBar: AppBar(
              title: Text(isEditing ? 'Edit Category' : 'Add New Category', style: AppTextStyles.h3),
              centerTitle: false,
              actions: [
                if (!isLoading)
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _submit(context),
                      icon: const FaIcon(FontAwesomeIcons.check, size: 14),
                      label: Text(isEditing ? 'Update Category' : 'Save Category'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            body: isLoading && isEditing && _nameController.text.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBasicInfoSection(context, state),
                          const SizedBox(height: 24),
                          _buildOrganizationSection(context, state),
                          const SizedBox(height: 24),
                          _buildImageSection(context),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildBasicInfoSection(BuildContext context, CategoryState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Basic Information', style: AppTextStyles.h3),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Category Name',
                  controller: _nameController,
                  hint: 'e.g. Italian Marble',
                  validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
                  onChanged: _onNameChanged,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildTextField(
                  label: 'Slug (URL identifier)',
                  controller: _slugController,
                  hint: 'e.g. italian-marble',
                  validator: (v) => v == null || v.isEmpty ? 'Slug is required' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: 'Description',
            controller: _descriptionController,
            hint: 'Describe what kind of products go into this category...',
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizationSection(BuildContext context, CategoryState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Organization & Status', style: AppTextStyles.h3),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Parent Category', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _parentId,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('None (Top Level)')),
                        ...state.categories
                            .where((c) => c.id != widget.categoryId) // Prevent circular reference
                            .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
                      ],
                      onChanged: (val) => setState(() => _parentId = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildTextField(
                  label: 'Sort Order',
                  controller: _sortOrderController,
                  hint: '0',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: Text('Active Status', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            subtitle: const Text('Inactive categories won\'t be visible in public selections.'),
            value: _isActive,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _isActive = val),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Category Image', style: AppTextStyles.h3),
          const SizedBox(height: 20),
          if (_imageUrl != null)
            Stack(
              children: [
                Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(image: NetworkImage(_imageUrl!), fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () => setState(() => _imageUrl = null),
                    icon: const Icon(Icons.close, color: Colors.white),
                    style: IconButton.styleFrom(backgroundColor: Colors.black54),
                  ),
                ),
              ],
            )
          else
            InkWell(
              onTap: () {
                // Mock image upload
                setState(() => _imageUrl = 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800&q=80');
              },
              child: Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                ),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.image, size: 32, color: AppColors.textSecondary),
                    SizedBox(height: 8),
                    Text('Upload Image', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          onChanged: onChanged,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final category = Category(
        id: widget.categoryId ?? '',
        name: _nameController.text,
        slug: _slugController.text,
        description: _descriptionController.text,
        image: _imageUrl,
        parentId: _parentId,
        active: _isActive,
        sortOrder: int.tryParse(_sortOrderController.text) ?? 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (isEditing) {
        context.read<CategoryBloc>().add(UpdateCategoryEvent(category));
      } else {
        context.read<CategoryBloc>().add(CreateCategoryEvent(category));
      }
      
      context.pop();
    }
  }
}
