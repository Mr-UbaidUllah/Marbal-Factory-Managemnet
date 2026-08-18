import 'package:factory_management/core/network/api_client.dart';
import 'package:factory_management/features/dashboard/data/models/dashboard_stats_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient client;

  DashboardRemoteDataSourceImpl({required this.client});

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    // Mocking API call
    await Future.delayed(const Duration(milliseconds: 500));
    return DashboardStatsModel(
      totalRevenue: 245600.0,
      totalOrders: 156,
      pendingOrders: 12,
      processingOrders: 8,
      completedOrders: 130,
      cancelledOrders: 6,
      pendingQuotes: 48,
      totalOrderValue: 84200.0,
    );
  }
}
