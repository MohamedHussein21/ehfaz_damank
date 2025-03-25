import 'package:equatable/equatable.dart';

class Register extends Equatable {
  final String name;
  final String phone;
  final String password;
  final String passwordConfirmation;

  const Register(
    this.name,
    this.phone,
    this.password,
    this.passwordConfirmation,
  );

  @override
  List<Object?> get props => [
        name,
        phone,
        password,
        passwordConfirmation,
      ];
}
