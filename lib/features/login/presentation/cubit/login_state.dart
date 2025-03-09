part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginLoaded extends LoginState {
  final UserModel user;
  final String token;

  const LoginLoaded(this.user, this.token);
}

class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object> get props => [message];
}
