import 'package:equatable/equatable.dart';

class Register extends Equatable {
  final String token;
  final String name;
  final String phone;

  const Register(
      {required this.name, required this.token, required this.phone});

  @override
  // TODO: implement props
  List<Object?> get props => [name, phone, token];
}
