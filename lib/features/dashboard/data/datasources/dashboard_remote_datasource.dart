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
    return const DashboardStatsModel(
      totalRevenue: 84200.0,
      activeProjects: 24,
      pendingQuotes: 48,
      lowStockAlerts: 12,
    );
  }
}
