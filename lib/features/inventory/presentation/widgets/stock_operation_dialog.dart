import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/inventory/domain/entities/inventory.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_event.dart';
import 'package:factory_management/features/inventory/presentation/bloc/inventory_state.dart';

enum StockOperationType { add, remove, adjust }

class StockOperationDialog extends StatefulWidget {
  final Inventory inventory;
  final StockOperationType type;

  const StockOperationDialog({
    super.key,
    required this.inventory,
    required this.type,
  });

  @override
  State<StockOperationDialog> createState() => _StockOperationDialogState();
}

class _StockOperationDialogState extends State<StockOperationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _reasonController = TextEditingController();
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.type == StockOperationType.adjust) {
      _quantityController.text = widget.inventory.quantity.toString();
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String get _title {
    switch (widget.type) {
      case StockOperationType.add:
        return 'Add Stock';
      case StockOperationType.remove:
        return 'Remove Stock';
      case StockOperationType.adjust:
        return 'Adjust Stock';
    }
  }

  Color get _primaryColor {
    switch (widget.type) {
      case StockOperationType.add:
        return AppColors.success;
      case StockOperationType.remove:
        return AppColors.error;
      case StockOperationType.adjust:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryBloc, InventoryState>(
      listener: (context, state) {
        if (state.status == InventoryStateStatus.success) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Stock ${widget.type.name}ed successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state.status == InventoryStateStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Operation failed'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: FaIcon(
                widget.type == StockOperationType.add
                    ? FontAwesomeIcons.plus
                    : widget.type == StockOperationType.remove
                        ? FontAwesomeIcons.minus
                        : FontAwesomeIcons.sliders,
                color: _primaryColor,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Text(_title, style: AppTextStyles.h3),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.inventory.productName,
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'SKU: ${widget.inventory.sku} | Current: ${widget.inventory.quantity} ${widget.inventory.unit}',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: widget.type == StockOperationType.adjust ? 'New Quantity' : 'Quantity',
                      suffixText: widget.inventory.unit,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Required';
                      final n = int.tryParse(value);
                      if (n == null) return 'Invalid number';
                      if (widget.type != StockOperationType.adjust && n <= 0) return 'Must be > 0';
                      if (widget.type == StockOperationType.remove && n > widget.inventory.availableQuantity) {
                        return 'Insufficient available stock';
                      }
                      if (widget.type == StockOperationType.adjust && n < 0) return 'Cannot be negative';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _reasonController,
                    decoration: InputDecoration(
                      labelText: 'Reason',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                  if (widget.type != StockOperationType.adjust) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _referenceController,
                      decoration: InputDecoration(
                        labelText: 'Reference (Order #, Bill #)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: 'Notes (Optional)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          BlocBuilder<InventoryBloc, InventoryState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state.status == InventoryStateStatus.submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: state.status == InventoryStateStatus.submitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(_title),
              );
            },
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final quantity = int.parse(_quantityController.text);
      final reason = _reasonController.text;
      final reference = _referenceController.text;
      final notes = _notesController.text;

      final bloc = context.read<InventoryBloc>();

      switch (widget.type) {
        case StockOperationType.add:
          bloc.add(AddStockEvent(
            productId: widget.inventory.productId,
            quantity: quantity,
            reason: reason,
            reference: reference,
            notes: notes,
          ));
          break;
        case StockOperationType.remove:
          bloc.add(RemoveStockEvent(
            productId: widget.inventory.productId,
            quantity: quantity,
            reason: reason,
            reference: reference,
            notes: notes,
          ));
          break;
        case StockOperationType.adjust:
          bloc.add(AdjustStockEvent(
            productId: widget.inventory.productId,
            newQuantity: quantity,
            reason: reason,
            notes: notes,
          ));
          break;
      }
    }
  }
}
