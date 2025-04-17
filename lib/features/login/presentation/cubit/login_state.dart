part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginClearingData extends LoginState {}

class LoginSuccess extends LoginState {
  final AuthResponse user;
  final String token;

  const LoginSuccess(this.user, this.token);
}

class LoginError extends LoginState {
  final String message;
  final String? errorCode;
  final Exception? exception;

  const LoginError(
    this.message, {
    this.errorCode,
    this.exception,
  });

  @override
  List<Object> get props => [message, errorCode ?? '', exception?.toString() ?? ''];

  /// Create a LoginError from an exception
  factory LoginError.fromException(Exception e, {String? customMessage}) {
    return LoginError(
      customMessage ?? 'An error occurred: ${e.toString()}',
      exception: e,
    );
  }

  /// Create a LoginError with an error code
  factory LoginError.withCode(String message, String code) {
    return LoginError(
      message,
      errorCode: code,
    );
  }
}

class LoggedOut extends LoginState {
  final bool success;
  final String? message;

  const LoggedOut({
    required this.success,
    this.message,
  });

  @override
  List<Object> get props => [success, message ?? ''];
}

class DataMigrationStarted extends LoginState {}

class DataMigrationCompleted extends LoginState {
  final bool success;
  final String? message;

  const DataMigrationCompleted({
    required this.success, 
    this.message,
  });

  @override
  List<Object> get props => [success, message ?? ''];
}

class StorageOperationFailed extends LoginState {
  final String operation;
  final String message;

  const StorageOperationFailed({
    required this.operation,
    required this.message,
  });

  @override
  List<Object> get props => [operation, message];
}
