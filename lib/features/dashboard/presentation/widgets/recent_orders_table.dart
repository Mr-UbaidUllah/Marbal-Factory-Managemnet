import 'package:flutter/material.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/shared/widgets/custom_card.dart';

class RecentOrdersTable extends StatelessWidget {
  const RecentOrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Orders', style: AppTextStyles.h3),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: AppTextStyles.label.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                AppColors.lightGray.withOpacity(0.5),
              ),
              columnSpacing: 40,
              dividerThickness: 0.5,
              columns: [
                _buildColumn('Order ID'),
                _buildColumn('Customer'),
                _buildColumn('Product'),
                _buildColumn('Quantity'),
                _buildColumn('Status'),
                _buildColumn('Price'),
                _buildColumn('Date'),
              ],
              rows: [
                _buildRow(
                  '#ORD-7241',
                  'John Doe',
                  'Carrara Marble',
                  '12 Slabs',
                  'Delivered',
                  '\$12,400',
                  'Oct 24, 2024',
                ),
                _buildRow(
                  '#ORD-7242',
                  'Sarah Smith',
                  'Black Granite',
                  '50 Tiles',
                  'Pending',
                  '\$4,200',
                  'Oct 24, 2024',
                ),
                _buildRow(
                  '#ORD-7243',
                  'Mike Ross',
                  'Emerald Quartz',
                  '5 Slabs',
                  'Approved',
                  '\$8,900',
                  'Oct 23, 2024',
                ),
                _buildRow(
                  '#ORD-7244',
                  'Harvey Specter',
                  'White Onyx',
                  '2 Slabs',
                  'Cancelled',
                  '\$15,000',
                  'Oct 22, 2024',
                ),
                _buildRow(
                  '#ORD-7245',
                  'Rachel Zane',
                  'Blue Pearl',
                  '20 Tiles',
                  'Delivered',
                  '\$3,100',
                  'Oct 21, 2024',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataColumn _buildColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  DataRow _buildRow(
    String id,
    String customer,
    String product,
    String qty,
    String status,
    String price,
    String date,
  ) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            id,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DataCell(Text(customer, style: AppTextStyles.bodySmall)),
        DataCell(Text(product, style: AppTextStyles.bodySmall)),
        DataCell(Text(qty, style: AppTextStyles.bodySmall)),
        DataCell(_buildStatusBadge(status)),
        DataCell(
          Text(price, style: AppTextStyles.price.copyWith(fontSize: 14)),
        ),
        DataCell(Text(date, style: AppTextStyles.bodySmall)),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Delivered':
        color = AppColors.success;
        break;
      case 'Pending':
        color = AppColors.warning;
        break;
      case 'Approved':
        color = AppColors.info;
        break;
      case 'Cancelled':
        color = AppColors.error;
        break;
      default:
        color = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppTextStyles.label.copyWith(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
