import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/exception_mapper.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:factory_management/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:factory_management/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardStats>> getDashboardStats() async {
    try {
      final stats = await remoteDataSource.getDashboardStats();
      return Right(stats);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }
}
