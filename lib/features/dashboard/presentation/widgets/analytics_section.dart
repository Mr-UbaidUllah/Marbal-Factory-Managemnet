import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/shared/widgets/custom_card.dart';

class AnalyticsSection extends StatelessWidget {
  const AnalyticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;
        
        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildRevenueOverview(),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildProductDistribution(),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _buildRevenueOverview(),
              const SizedBox(height: 24),
              _buildProductDistribution(),
            ],
          );
        }
      },
    );
  }

  Widget _buildRevenueOverview() {
    return CustomCard(
      height: 400,
      margin: const EdgeInsets.only(bottom: 16), onTap: () {  }, title: '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Revenue Overview', style: AppTextStyles.h3),
              _buildChartFilters(),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(child: _buildRevenueChart()),
        ],
      ),
    );
  }

  Widget _buildProductDistribution() {
    return CustomCard(
      height: 400,
      margin: const EdgeInsets.only(bottom: 16), onTap: () {  }, title: '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Distribution', style: AppTextStyles.h3),
          const SizedBox(height: 32),
          Expanded(child: _buildDistributionChart()),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildChartFilters() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildFilterItem('Week', false),
          _buildFilterItem('Month', true),
          _buildFilterItem('Year', false),
        ],
      ),
    );
  }

  Widget _buildFilterItem(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        boxShadow: isSelected
            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
            : null,
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: AppColors.border.withOpacity(0.5), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                if (value.toInt() >= 0 && value.toInt() < days.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      days[value.toInt()],
                      style: AppTextStyles.bodySmall,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 3),
              const FlSpot(1, 4),
              const FlSpot(2, 3.5),
              const FlSpot(3, 5),
              const FlSpot(4, 4.5),
              const FlSpot(5, 6),
              const FlSpot(6, 5.5),
            ],
            isCurved: true,
            color: AppColors.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 60,
        sections: [
          PieChartSectionData(
            color: AppColors.primary,
            value: 40,
            title: '40%',
            radius: 20,
            titleStyle: AppTextStyles.label.copyWith(color: Colors.white),
          ),
          PieChartSectionData(
            color: AppColors.gold,
            value: 30,
            title: '30%',
            radius: 20,
            titleStyle: AppTextStyles.label.copyWith(color: Colors.white),
          ),
          PieChartSectionData(
            color: AppColors.info,
            value: 15,
            title: '15%',
            radius: 20,
            titleStyle: AppTextStyles.label.copyWith(color: Colors.white),
          ),
          PieChartSectionData(
            color: AppColors.primaryLight,
            value: 15,
            title: '15%',
            radius: 20,
            titleStyle: AppTextStyles.label.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      children: [
        _buildLegendItem('Marble Slabs', AppColors.primary),
        const SizedBox(height: 8),
        _buildLegendItem('Granite Tiles', AppColors.gold),
        const SizedBox(height: 8),
        _buildLegendItem('Custom Stones', AppColors.info),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.bodySmall),
        const Spacer(),
        Text('84 sales', style: AppTextStyles.label),
      ],
    );
  }
}
