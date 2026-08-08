import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/core/utils/validators.dart';
import 'package:factory_management/features/products/domain/entities/product.dart';
import 'package:factory_management/features/products/presentation/bloc/product_bloc.dart';
import 'package:factory_management/features/products/presentation/bloc/product_event.dart';
import 'package:factory_management/features/products/presentation/bloc/product_state.dart' hide ProductStatus;
import 'package:uuid/uuid.dart';

class ProductFormPage extends StatefulWidget {
  final String? productId;

  const ProductFormPage({super.key, this.productId});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditMode = false;
  bool _hasUnsavedChanges = false;

  // Controllers
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _minStockController = TextEditingController();
  final _unitController = TextEditingController(text: 'sqm');
  final _dimensionsController = TextEditingController();
  final _thicknessController = TextEditingController();
  final _colorController = TextEditingController();
  final _originController = TextEditingController();
  final _weightController = TextEditingController();
  
  // Advanced Specifications Controllers
  final _waterAbsorptionController = TextEditingController();
  final _hardnessController = TextEditingController();
  final _applicationController = TextEditingController();
  final _edgeTypeController = TextEditingController();

  String? _selectedCategory;
  String? _selectedMaterial;
  String? _selectedFinish;
  bool _featured = false;
  bool _active = true;
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.productId != null;
  }

  void _onChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  void _populateFields(Product product) {
    _nameController.text = product.name;
    _skuController.text = product.sku;
    _descriptionController.text = product.description;
    _shortDescriptionController.text = product.shortDescription;
    _priceController.text = product.price.toString();
    _discountPriceController.text = product.discountPrice.toString();
    _stockController.text = product.stockQuantity.toString();
    _minStockController.text = product.minimumStock.toString();
    _unitController.text = product.unit;
    _dimensionsController.text = product.dimensions;
    _thicknessController.text = product.thickness;
    _colorController.text = product.color;
    _originController.text = product.originCountry;
    _weightController.text = product.weight.toString();
    
    _waterAbsorptionController.text = product.waterAbsorption ?? '';
    _hardnessController.text = product.hardness ?? '';
    _applicationController.text = product.application ?? '';
    _edgeTypeController.text = product.edgeType ?? '';
    
    _selectedCategory = product.categoryId;
    _selectedMaterial = product.materialType;
    _selectedFinish = product.finish;
    _featured = product.featured;
    _active = product.active;
    _images = List.from(product.images);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _descriptionController.dispose();
    _shortDescriptionController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _unitController.dispose();
    _dimensionsController.dispose();
    _thicknessController.dispose();
    _colorController.dispose();
    _originController.dispose();
    _weightController.dispose();
    _waterAbsorptionController.dispose();
    _hardnessController.dispose();
    _applicationController.dispose();
    _edgeTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = sl<ProductBloc>();
        if (_isEditMode) {
          bloc.add(GetProductEvent(widget.productId!));
        }
        return bloc;
      },
      child: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state.status == ProductStatus.success && _isEditMode && state.selectedProduct != null) {
            _populateFields(state.selectedProduct!);
          }
          if (state.status == ProductStatus.success && state.isSubmitting == false && _hasUnsavedChanges) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_isEditMode ? 'Product updated successfully' : 'Product created successfully')),
            );
            context.pop();
          }
        },
        child: PopScope(
          canPop: !_hasUnsavedChanges,
          onPopInvoked: (didPop) async {
            if (didPop) return;
            final shouldPop = await _showExitConfirmation(context);
            if (shouldPop && context.mounted) {
              context.pop();
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.surface,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const FaIcon(FontAwesomeIcons.xmark, color: AppColors.textPrimary, size: 20),
                onPressed: () => Navigator.maybePop(context),
              ),
              title: Text(_isEditMode ? 'Edit Product' : 'Add New Product', style: AppTextStyles.h3),
              actions: [
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ElevatedButton(
                        onPressed: state.isSubmitting ? null : () => _submit(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: state.isSubmitting 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(_isEditMode ? 'Save Changes' : 'Create Product'),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                onChanged: _onChanged,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormSections(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormSections() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1000;

    if (isMobile) {
      return Column(
        children: [
          _buildBasicInfoSection(),
          const SizedBox(height: 24),
          _buildPricingAndInventorySection(),
          const SizedBox(height: 24),
          _buildSpecificationsSection(),
          const SizedBox(height: 24),
          _buildStatusSection(),
          const SizedBox(height: 24),
          _buildImageSection(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildPricingAndInventorySection(),
              const SizedBox(height: 24),
              _buildSpecificationsSection(),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [
              _buildStatusSection(),
              const SizedBox(height: 24),
              _buildImageSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildCard(
      title: 'Basic Information',
      children: [
        _buildTextField(
          label: 'Product Name', 
          controller: _nameController, 
          hint: 'e.g. Italian Carreras Marble', 
          validator: (v) => Validators.validateNotEmpty(v, 'Name')
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'SKU', 
          controller: _skuController, 
          hint: 'e.g. MAR-CAR-001', 
          validator: (v) => Validators.validateNotEmpty(v, 'SKU')
        ),
        const SizedBox(height: 20),
        _buildTextField(label: 'Short Description', controller: _shortDescriptionController, hint: 'Brief summary for listings'),
        const SizedBox(height: 20),
        _buildTextField(label: 'Full Description', controller: _descriptionController, hint: 'Detailed product information', maxLines: 5),
      ],
    );
  }

  Widget _buildPricingAndInventorySection() {
    return _buildCard(
      title: 'Pricing & Inventory',
      children: [
        Row(
          children: [
            Expanded(child: _buildTextField(label: 'Price', controller: _priceController, hint: '0.00', prefix: const Padding(
              padding: EdgeInsets.all(12.0),
              child: FaIcon(FontAwesomeIcons.moneyBill, size: 16),
            ), keyboardType: TextInputType.number)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(label: 'Discount Price', controller: _discountPriceController, hint: '0.00', prefix: const Padding(
              padding: EdgeInsets.all(12.0),
              child: FaIcon(FontAwesomeIcons.tag, size: 16),
            ), keyboardType: TextInputType.number)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildTextField(label: 'Stock Quantity', controller: _stockController, hint: '0', keyboardType: TextInputType.number)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(label: 'Minimum Stock', controller: _minStockController, hint: '0', keyboardType: TextInputType.number)),
          ],
        ),
        const SizedBox(height: 20),
        _buildTextField(label: 'Unit of Measure', controller: _unitController, hint: 'e.g. sqm, pcs, tons'),
      ],
    );
  }

  Widget _buildSpecificationsSection() {
    return _buildCard(
      title: 'Specifications',
      children: [
        Row(
          children: [
            Expanded(child: _buildDropdown(label: 'Category', value: _selectedCategory, items: ['1', '2', '3', '4'], itemLabels: ['Marble', 'Granite', 'Onyx', 'Travertine'], onChanged: (v) => setState(() => _selectedCategory = v))),
            const SizedBox(width: 16),
            Expanded(child: _buildDropdown(label: 'Material Type', value: _selectedMaterial, items: ['Marble', 'Granite', 'Onyx', 'Travertine'], onChanged: (v) => setState(() => _selectedMaterial = v))),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildDropdown(label: 'Finish', value: _selectedFinish, items: ['Polished', 'Honed', 'Brushed', 'Weathered', 'Leathered'], onChanged: (v) => setState(() => _selectedFinish = v))),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(label: 'Color', controller: _colorController, hint: 'e.g. White, Grey')),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildTextField(label: 'Thickness', controller: _thicknessController, hint: 'e.g. 2cm, 3cm')),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(label: 'Dimensions', controller: _dimensionsController, hint: 'e.g. 300x150cm')),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildTextField(label: 'Country of Origin', controller: _originController, hint: 'e.g. Italy')),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(label: 'Weight (kg)', controller: _weightController, hint: '0.0', keyboardType: TextInputType.number)),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 20),
        Text('Advanced Specifications', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField(label: 'Water Absorption', controller: _waterAbsorptionController, hint: 'e.g. 0.12%')),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(label: 'Hardness', controller: _hardnessController, hint: 'e.g. 3 Mohs')),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildTextField(label: 'Application', controller: _applicationController, hint: 'e.g. Indoor, Outdoor, Wall')),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(label: 'Edge Type', controller: _edgeTypeController, hint: 'e.g. Bevel, Bullnose')),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusSection() {
    return _buildCard(
      title: 'Product Status',
      children: [
        SwitchListTile(
          title: Text('Active', style: AppTextStyles.bodyMedium),
          subtitle: Text('Visible in catalog and website', style: AppTextStyles.bodySmall),
          value: _active,
          activeColor: AppColors.primary,
          onChanged: (v) => setState(() {
            _active = v;
            _onChanged();
          }),
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(),
        SwitchListTile(
          title: Text('Featured', style: AppTextStyles.bodyMedium),
          subtitle: Text('Display on homepage featured section', style: AppTextStyles.bodySmall),
          value: _featured,
          activeColor: AppColors.primary,
          onChanged: (v) => setState(() {
            _featured = v;
            _onChanged();
          }),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return _buildCard(
      title: 'Product Images',
      children: [
        if (_images.isNotEmpty) ...[
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _images.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final item = _images.removeAt(oldIndex);
                _images.insert(newIndex, item);
                _onChanged();
              });
            },
            itemBuilder: (context, index) => Container(
              key: ValueKey(_images[index]),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.gripLines, size: 20, color: AppColors.textSecondary),
                  const SizedBox(width: 12),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(image: NetworkImage(_images[index]), fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Image ${index + 1}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                        if (index == 0)
                          Text('Cover Image', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.trashCan, color: AppColors.error, size: 20),
                    onPressed: () => setState(() {
                      _images.removeAt(index);
                      _onChanged();
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        InkWell(
          onTap: () {
            // Mock upload
            setState(() {
              _images.add('https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800&q=80&random=${_images.length}');
              _hasUnsavedChanges = true;
            });
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), style: BorderStyle.solid), // Should be dashed
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primary.withValues(alpha: 0.05),
            ),
            child: Column(
              children: [
                const FaIcon(FontAwesomeIcons.image, color: AppColors.primary, size: 32),
                const SizedBox(height: 8),
                Text('Upload Images', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                Text('Support Multiple Uploads', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h3),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    Widget? prefix,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefix,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    List<String>? itemLabels,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: List.generate(items.length, (index) {
                return DropdownMenuItem(
                  value: items[index],
                  child: Text(itemLabels != null ? itemLabels[index] : items[index]),
                );
              }),
              onChanged: (val) {
                onChanged(val);
                _onChanged();
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Stay')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Leave')),
        ],
      )
    ) ?? false;
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: _isEditMode ? widget.productId! : const Uuid().v4(),
        name: _nameController.text,
        slug: _nameController.text.toLowerCase().replaceAll(' ', '-'),
        sku: _skuController.text,
        categoryId: _selectedCategory ?? '1',
        categoryName: _selectedCategory == '1' ? 'Marble' : _selectedCategory == '2' ? 'Granite' : _selectedCategory == '3' ? 'Onyx' : 'Travertine',
        description: _descriptionController.text,
        shortDescription: _shortDescriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        discountPrice: double.tryParse(_discountPriceController.text) ?? 0,
        stockQuantity: int.tryParse(_stockController.text) ?? 0,
        minimumStock: int.tryParse(_minStockController.text) ?? 0,
        unit: _unitController.text,
        dimensions: _dimensionsController.text,
        thickness: _thicknessController.text,
        finish: _selectedFinish ?? 'Polished',
        color: _colorController.text,
        originCountry: _originController.text,
        materialType: _selectedMaterial ?? 'Marble',
        weight: double.tryParse(_weightController.text) ?? 0,
        waterAbsorption: _waterAbsorptionController.text,
        hardness: _hardnessController.text,
        application: _applicationController.text,
        edgeType: _edgeTypeController.text,
        featured: _featured,
        active: _active,
        images: _images,
        createdAt: _isEditMode ? DateTime.now() : DateTime.now(), // Should keep original in edit mode normally
        updatedAt: DateTime.now(),
      );

      if (_isEditMode) {
        context.read<ProductBloc>().add(UpdateProductEvent(product));
      } else {
        context.read<ProductBloc>().add(CreateProductEvent(product));
      }
    }
  }
}
