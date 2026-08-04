import 'package:equatable/equatable.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/dashboard/domain/entities/dashboard_stats.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final DashboardStats? stats;
  final Failure? failure;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.stats,
    this.failure,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardStats? stats,
    Failure? failure,
  }) {
    return DashboardState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, stats, failure];
}
