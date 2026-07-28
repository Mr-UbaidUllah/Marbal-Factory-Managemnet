import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final double totalRevenue;
  final int activeProjects;
  final int pendingQuotes;
  final int lowStockAlerts;

  const DashboardStats({
    required this.totalRevenue,
    required this.activeProjects,
    required this.pendingQuotes,
    required this.lowStockAlerts,
  });

  @override
  List<Object?> get props => [totalRevenue, activeProjects, pendingQuotes, lowStockAlerts];
}
