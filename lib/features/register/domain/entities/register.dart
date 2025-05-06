import 'package:equatable/equatable.dart';

class Register extends Equatable {
  final String name;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String email;

  const Register(
    this.name,
    this.phone,
    this.password,
    this.passwordConfirmation,
    this.email,
  );

  @override
  List<Object?> get props => [
        name,
        phone,
        password,
        passwordConfirmation,
        email,
      ];
}
