part of 'register_screen_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterScreenInitial extends RegisterState {}

class RegisterScreenLoading extends RegisterState {}

class RegisterScreenLoaded extends RegisterState {
  final UserModel user;
  final String token;

  const RegisterScreenLoaded(this.user, this.token);
}

class RegisterScreenError extends RegisterState {
  final String message;

  const RegisterScreenError(this.message);

  @override
  List<Object> get props => [message];
}
