import 'package:factory_management/features/dashboard/domain/entities/dashboard_stats.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.totalRevenue,
    required super.activeProjects,
    required super.pendingQuotes,
    required super.lowStockAlerts,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      activeProjects: json['activeProjects'] as int,
      pendingQuotes: json['pendingQuotes'] as int,
      lowStockAlerts: json['lowStockAlerts'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRevenue': totalRevenue,
      'activeProjects': activeProjects,
      'pendingQuotes': pendingQuotes,
      'lowStockAlerts': lowStockAlerts,
    };
  }
}
