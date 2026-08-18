import 'package:flutter/material.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/shared/widgets/custom_card.dart';


class ActivityCalendar extends StatelessWidget {
  const ActivityCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16), onTap: () {  }, title: '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Schedule', style: AppTextStyles.h3),
              const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
            ],
          ),
          const SizedBox(height: 24),
          _buildCalendarHeader(),
          const SizedBox(height: 16),
          _buildCalendarGrid(),
          const SizedBox(height: 24),
          Text('Upcoming Events', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildEventItem('Factory Visit', '10:00 AM', AppColors.gold),
          _buildEventItem('Order #7242 Delivery', '02:30 PM', AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('October 2024', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        Row(
          children: [
            Icon(Icons.arrow_left, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Icon(Icons.arrow_right_alt_outlined, size: 16, color: AppColors.textSecondary),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 31,
      itemBuilder: (context, index) {
        final day = index + 1;
        final isSelected = day == 24;
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            day.toString(),
            style: AppTextStyles.bodySmall.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventItem(String title, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                Text(time, style: AppTextStyles.label.copyWith(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
