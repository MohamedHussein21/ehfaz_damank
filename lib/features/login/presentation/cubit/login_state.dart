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
  final String? responseData;

  const LoginError(
    this.message, {
    this.errorCode,
    this.responseData,
  });

  @override
  List<Object> get props => [message, errorCode ?? '', responseData ?? ''];

  factory LoginError.fromResponse(Map<String, dynamic> response) {
    return LoginError(
      response['msg'] ?? 'error',
      responseData: response['data']?.toString(),
    );
  }

  factory LoginError.fromException(Exception e, {String? customMessage}) {
    return LoginError(
      customMessage ?? 'An error occurred: ${e.toString()}',
      responseData: e.toString(),
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

class ChangePasswordLoading extends LoginState {}

class ChangePasswordSuccess extends LoginState {
  final VerifyResponseModel verifyResponseModel;
  const ChangePasswordSuccess(this.verifyResponseModel);
}

class ChangePasswordError extends LoginState {
  final String message;
  const ChangePasswordError(this.message);
}

class VerifyForgetPasswordError extends LoginState {
  final String message;
  const VerifyForgetPasswordError(this.message);
}

class VerifyForgetPasswordSuccess extends LoginState {
  final SentModel sentModel;
  const VerifyForgetPasswordSuccess(this.sentModel);
}

class VerifyForgetPasswordLoading extends LoginState {}

class SendVerifyForgetPasswordEmailLoading extends LoginState {}

class SendVerifyForgetPasswordEmailSuccess extends LoginState {
  final RegisterModel registerModel;
  const SendVerifyForgetPasswordEmailSuccess(this.registerModel);
}

class SendVerifyForgetPasswordEmailError extends LoginState {
  final String message;
  const SendVerifyForgetPasswordEmailError(this.message);
}
