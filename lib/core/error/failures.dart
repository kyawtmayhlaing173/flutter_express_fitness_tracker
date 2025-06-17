import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});

  @override
  List<Object> get props => [message, statusCode ?? ''];
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;
  const ValidationFailure(super.message, {this.errors});

  @override
  List<Object> get props => [message, errors ?? ''];
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
