class UserModel {
  final String email;
  final String password;
  final String? token;

  UserModel({required this.email, required this.password, this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      password: json['password'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'token': token,
    };
  }
}
