import 'package:equatable/equatable.dart';
import 'package:factory_management/features/dashboard/domain/entities/dashboard_stats.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final DashboardStats? stats;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.stats,
    this.errorMessage,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardStats? stats,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, stats, errorMessage];
}
