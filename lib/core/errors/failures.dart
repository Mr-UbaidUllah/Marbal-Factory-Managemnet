import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic details;

  const Failure(this.message, {this.code, this.details});

  @override
  List<Object?> get props => [message, code, details];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code, super.details});
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code, super.details});
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code, super.details});
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code, super.details});
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message, {super.code, super.details});
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.code, super.details});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message, {super.code, super.details});
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.code, super.details});
}
