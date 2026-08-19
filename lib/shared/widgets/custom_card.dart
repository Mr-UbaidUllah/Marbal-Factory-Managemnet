import 'package:flutter/material.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? color;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final String? title;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.borderRadius = 20,
    this.boxShadow,
    this.border,
    this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget current = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: (title != null && title!.isNotEmpty)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title!, style: AppTextStyles.h1),
                const SizedBox(height: 16),
                child,
              ],
            )
          : child,
    );

    if (onTap != null) {
      current = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: current,
      );
    }

    return current;
  }
}
