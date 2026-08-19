import 'package:flutter/material.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import '../../domain/entities/payment_status.dart';

class PaymentStatusBadge extends StatelessWidget {
  final PaymentStatus status;
  final bool isSmall;

  const PaymentStatusBadge({
    super.key,
    required this.status,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isSmall ? 6 : 8,
          height: isSmall ? 6 : 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: isSmall ? 4 : 6),
        Text(
          status.name,
          style: AppTextStyles.bodySmall.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: isSmall ? 11 : 12,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return AppColors.warning;
      case PaymentStatus.partial:
        return AppColors.info;
      case PaymentStatus.paid:
        return AppColors.success;
      case PaymentStatus.refunded:
        return AppColors.error;
    }
  }
}
