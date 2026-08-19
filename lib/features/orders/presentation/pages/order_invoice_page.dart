import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/entities/payment_status.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../widgets/payment_status_badge.dart';

class OrderInvoicePage extends StatefulWidget {
  final String orderId;

  const OrderInvoicePage({super.key, required this.orderId});

  @override
  State<OrderInvoicePage> createState() => _OrderInvoicePageState();
}

class _OrderInvoicePageState extends State<OrderInvoicePage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(GetOrderDetail(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isMobile = mediaQuery.size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: BackButton(color: AppColors.textPrimary),
        title: Text('Tax Invoice', style: AppTextStyles.h3),
        actions: [
          if (!isMobile)
            TextButton.icon(
              icon: const Icon(Icons.print_outlined, size: 18),
              label: const Text('Print'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Print functionality will be available in a future update.')),
                );
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.download_outlined, color: AppColors.textPrimary),
            onPressed: () {},
            tooltip: 'Download PDF',
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.status == OrderStatusState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final order = state.selectedOrder;
          if (order == null) return const Center(child: Text('Order not found.'));

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 16 : 32,
              horizontal: isMobile ? 8 : 16,
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(isMobile ? 0 : 8),
                  boxShadow: isMobile
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                ),
                child: Column(
                  children: [
                    // Top Accent Bar
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(isMobile ? 0 : 8)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(isMobile ? 20.0 : 48.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(isMobile),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: isMobile ? 24 : 32),
                            child: const Divider(thickness: 1.5),
                          ),
                          _buildInvoiceMeta(order, isMobile),
                          const SizedBox(height: 32),
                          _buildAddresses(order, isMobile),
                          const SizedBox(height: 40),
                          _buildItemsTable(order.items, isMobile),
                          const SizedBox(height: 32),
                          _buildTotals(order, isMobile),
                          SizedBox(height: isMobile ? 48 : 64),
                          _buildFooter(order, isMobile),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ALAM MARBLE & GRANITE',
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.primaryDark,
                  letterSpacing: 1,
                  fontSize: isMobile ? 18 : 24,
                ),
              ),
              Text(
                'FACTORY L.L.C.',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  fontSize: isMobile ? 14 : 16,
                ),
              ),
              const SizedBox(height: 16),
              _buildCompanyDetail(Icons.location_on_outlined, 'Industrial Area, Riyadh, KSA'),
              _buildCompanyDetail(Icons.phone_outlined, '+966 11 123 4567'),
              _buildCompanyDetail(Icons.email_outlined, 'info@alammarble.com'),
              _buildCompanyDetail(Icons.language_outlined, 'www.alammarble.com'),
            ],
          ),
        ),
        if (!isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightGray.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.factory, size: 64, color: AppColors.primary),
              ),
              const SizedBox(height: 8),
              Text('VAT #: 300000000000003', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
      ],
    );
  }

  Widget _buildCompanyDetail(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textTertiary),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceMeta(Order order, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('INVOICE TO', style: AppTextStyles.label.copyWith(letterSpacing: 1)),
              const SizedBox(height: 8),
              Text(order.customerName, style: isMobile ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold) : AppTextStyles.h3),
              Text(order.customerPhone, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('INVOICE NO: ', style: AppTextStyles.label),
                Text(order.orderNumber.replaceFirst('ORD', 'INV'), style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('DATE: ', style: AppTextStyles.label),
                Text(DateFormat('dd MMM yyyy').format(order.createdAt), style: AppTextStyles.bodyMedium),
              ],
            ),
            const SizedBox(height: 12),
            PaymentStatusBadge(status: order.paymentStatus),
          ],
        ),
      ],
    );
  }

  Widget _buildAddresses(Order order, bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DELIVERY ADDRESS', style: AppTextStyles.label.copyWith(letterSpacing: 1)),
          const SizedBox(height: 8),
          Text(order.deliveryAddress, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 20),
          Text('QUOTE REFERENCE', style: AppTextStyles.label.copyWith(letterSpacing: 1)),
          const SizedBox(height: 8),
          Text(order.quoteNumber, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DELIVERY ADDRESS', style: AppTextStyles.label.copyWith(letterSpacing: 1)),
              const SizedBox(height: 8),
              Text(order.deliveryAddress, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        const SizedBox(width: 48),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('QUOTE REFERENCE', style: AppTextStyles.label.copyWith(letterSpacing: 1)),
              const SizedBox(height: 8),
              Text(order.quoteNumber, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemsTable(List<OrderItem> items, bool isMobile) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(flex: 4, child: Text('DESCRIPTION', style: AppTextStyles.label.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isMobile ? 10 : 12))),
              if (!isMobile)
                Expanded(flex: 1, child: Text('QTY', style: AppTextStyles.label.copyWith(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              if (!isMobile)
                Expanded(flex: 2, child: Text('UNIT PRICE', style: AppTextStyles.label.copyWith(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
              Expanded(flex: 2, child: Text('AMOUNT', style: AppTextStyles.label.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isMobile ? 10 : 12), textAlign: TextAlign.right)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = items[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.productName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, fontSize: isMobile ? 13 : 14)),
                        Text('SKU: ${item.sku}', style: AppTextStyles.label.copyWith(fontSize: 10)),
                        if (isMobile)
                          Text('${item.quantity} ${item.unit} @ ${item.unitPrice.toStringAsFixed(2)}', 
                               style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
                      ],
                    ),
                  ),
                  if (!isMobile)
                    Expanded(flex: 1, child: Text('${item.quantity} ${item.unit}', style: AppTextStyles.bodySmall, textAlign: TextAlign.center)),
                  if (!isMobile)
                    Expanded(flex: 2, child: Text(item.unitPrice.toStringAsFixed(2), style: AppTextStyles.bodySmall, textAlign: TextAlign.right)),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(item.subtotal.toStringAsFixed(2), 
                             style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, fontSize: isMobile ? 13 : 14), 
                             textAlign: TextAlign.right),
                        if (item.discount > 0)
                          Text('-${item.discount.toStringAsFixed(2)}', style: AppTextStyles.label.copyWith(color: AppColors.error, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTotals(Order order, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: isMobile ? double.infinity : 300,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.lightGray.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _totalRow('Subtotal', order.subtotal),
              _totalRow('Discount', -order.discount, isNegative: true),
              _totalRow('VAT (15%)', order.tax),
              _totalRow('Delivery Charges', order.deliveryCharges),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(thickness: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('GRAND TOTAL', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    'SAR ${order.total.toStringAsFixed(2)}',
                    style: (isMobile ? AppTextStyles.h3 : AppTextStyles.h2).copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _totalRow(String label, double value, {bool isNegative = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          Text(
            '${isNegative ? '-' : ''}SAR ${value.abs().toStringAsFixed(2)}',
            style: AppTextStyles.bodySmall.copyWith(
              color: isNegative ? AppColors.error : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(Order order, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TERMS & CONDITIONS', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('1. Goods once sold will not be taken back.', style: AppTextStyles.bodySmall),
                  Text('2. This is a computer-generated invoice and does not require a physical signature.', style: AppTextStyles.bodySmall),
                  if (order.orderNotes != null && order.orderNotes!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('NOTES', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(order.orderNotes!, style: AppTextStyles.bodySmall),
                  ],
                ],
              ),
            ),
            if (!isMobile) ...[
              const SizedBox(width: 48),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    Container(height: 1, color: AppColors.textTertiary),
                    const SizedBox(height: 8),
                    Text('Authorized Signatory', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                Container(width: 200, height: 1, color: AppColors.textTertiary),
                const SizedBox(height: 8),
                Text('Authorized Signatory', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
        const SizedBox(height: 48),
        Center(
          child: Text(
            'Thank you for choosing Alam Marble & Granite Factory',
            style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic, color: AppColors.textTertiary, fontSize: isMobile ? 10 : 12),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
