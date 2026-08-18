import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.totalRevenue,
    required super.totalOrders,
    required super.pendingOrders,
    required super.processingOrders,
    required super.completedOrders,
    required super.cancelledOrders,
    required super.pendingQuotes,
    required super.totalOrderValue,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalOrders: json['totalOrders'] as int,
      pendingOrders: json['pendingOrders'] as int,
      processingOrders: json['processingOrders'] as int,
      completedOrders: json['completedOrders'] as int,
      cancelledOrders: json['cancelledOrders'] as int,
      pendingQuotes: json['pendingQuotes'] as int,
      totalOrderValue: (json['totalOrderValue'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRevenue': totalRevenue,
      'totalOrders': totalOrders,
      'pendingOrders': pendingOrders,
      'processingOrders': processingOrders,
      'completedOrders': completedOrders,
      'cancelledOrders': cancelledOrders,
      'pendingQuotes': pendingQuotes,
      'totalOrderValue': totalOrderValue,
    };
  }
}
