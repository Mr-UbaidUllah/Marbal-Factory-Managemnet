import 'package:dio/dio.dart';
import 'package:factory_management/core/errors/failures.dart';

class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const NetworkFailure('Connection timed out. Please check your internet connection.');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ?? 'Unexpected server error occurred.';
          return ServerFailure('Server Error ($statusCode): $message');
        case DioExceptionType.cancel:
          return const ServerFailure('Request was cancelled.');
        default:
          return const NetworkFailure('A network error occurred. Please try again.');
      }
    }
    return ServerFailure(error.toString());
  }
}
