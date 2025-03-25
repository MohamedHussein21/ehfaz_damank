part of 'register_screen_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterScreenInitial extends RegisterState {}

class RegisterScreenLoading extends RegisterState {}

class RegisterScreenSuccess extends RegisterState {
  final RegisterModel user;

  const RegisterScreenSuccess(
    this.user,
  );
}

class RegisterScreenError extends RegisterState {
  final String message;

  const RegisterScreenError(this.message);

  @override
  List<Object> get props => [message];
}

class RegisterScreenRememberMe extends RegisterState {
  final bool rememberMe;

  const RegisterScreenRememberMe(this.rememberMe);

  @override
  List<Object> get props => [rememberMe];
}

class RegisterScreenVerify extends RegisterState {}

class RegisterScreenVerifySuccess extends RegisterState {
  final VerifyResponse user;

  const RegisterScreenVerifySuccess(this.user);
}

class RegisterScreenVerifyError extends RegisterState {
  final String message;

  const RegisterScreenVerifyError(this.message);
}

class RegisterScreenVerifyLoading extends RegisterState {}
