import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final double totalRevenue;
  final int totalOrders;
  final int pendingOrders;
  final int processingOrders;
  final int completedOrders;
  final int cancelledOrders;
  final int pendingQuotes;
  final double totalOrderValue;

  const DashboardStats({
    required this.totalRevenue,
    required this.totalOrders,
    required this.pendingOrders,
    required this.processingOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.pendingQuotes,
    required this.totalOrderValue,
  });

  @override
  List<Object?> get props => [
        totalRevenue,
        totalOrders,
        pendingOrders,
        processingOrders,
        completedOrders,
        cancelledOrders,
        pendingQuotes,
        totalOrderValue,
      ];
}
