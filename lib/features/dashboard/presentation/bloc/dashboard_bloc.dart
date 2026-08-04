import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:factory_management/features/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';
import 'package:factory_management/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:factory_management/features/dashboard/presentation/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardStatsUseCase getDashboardStatsUseCase;

  DashboardBloc({
    required this.getDashboardStatsUseCase,
  }) : super(const DashboardState()) {
    on<GetDashboardStatsEvent>(_onGetDashboardStats);
  }

  Future<void> _onGetDashboardStats(
    GetDashboardStatsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    final result = await getDashboardStatsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: DashboardStatus.failure,
        failure: failure,
      )),
      (stats) => emit(state.copyWith(
        status: DashboardStatus.success,
        stats: stats,
      )),
    );
  }
}
