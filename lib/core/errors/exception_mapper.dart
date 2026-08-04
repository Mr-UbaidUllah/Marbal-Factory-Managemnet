import 'dart:io';
import 'package:dio/dio.dart';
import 'package:factory_management/core/errors/exceptions.dart';
import 'package:factory_management/core/errors/failures.dart';

class ExceptionMapper {
  static Failure map(dynamic exception) {
    if (exception is DioException) {
      return _handleDioError(exception);
    } else if (exception is ServerException) {
      return ServerFailure(exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is SocketException) {
      return const NetworkFailure('No Internet connection');
    } else if (exception is FormatException) {
      return const ServerFailure('Bad response format');
    } else {
      return UnknownFailure(exception.toString());
    }
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure('Connection timed out');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? error.message;
        
        if (statusCode == 401 || statusCode == 403) {
          return AuthenticationFailure(message ?? 'Unauthorized');
        } else if (statusCode == 400) {
          return ValidationFailure(message ?? 'Invalid request');
        } else if (statusCode == 404) {
          return const ServerFailure('Resource not found', code: '404');
        } else if (statusCode != null && statusCode >= 500) {
          return ServerFailure(message ?? 'Internal server error', code: statusCode.toString());
        }
        return ServerFailure(message ?? 'Server error', code: statusCode?.toString());
      case DioExceptionType.cancel:
        return const ServerFailure('Request cancelled');
      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection');
      case DioExceptionType.unknown:
      default:
        if (error.error is SocketException) {
          return const NetworkFailure('No internet connection');
        }
        return UnknownFailure(error.message ?? 'Unknown network error');
    }
  }
}
