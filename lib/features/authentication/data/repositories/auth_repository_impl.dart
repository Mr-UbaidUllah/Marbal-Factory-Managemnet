import 'package:dartz/dartz.dart';
import 'package:factory_management/core/errors/exceptions.dart';
import 'package:factory_management/core/errors/failures.dart';
import 'package:factory_management/features/authentication/data/datasource/auth_local_data_source.dart';
import 'package:factory_management/features/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:factory_management/features/authentication/data/models/user_model.dart';
import 'package:factory_management/features/authentication/domain/entities/user_entity.dart';
import 'package:factory_management/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      await localDataSource.saveUser(userModel);
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSession(UserEntity user) async {
    try {
      await localDataSource.saveUser(UserModel.fromEntity(user));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearSession() async {
    try {
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isSessionValid() async {
    try {
      final isValid = await localDataSource.hasToken();
      return Right(isValid);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
