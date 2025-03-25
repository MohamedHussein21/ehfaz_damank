class AuthResponse {
  final String msg;
  final String apiToken;
  final UserData data;

  AuthResponse({
    required this.msg,
    required this.apiToken,
    required this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      msg: json['msg'],
      apiToken: json['api_token'],
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {
  final int id;
  final String name;
  final String? email;
  final String phone;
  final String? emailVerifiedAt;
  final String? googleToken;
  final String type;
  final int confirmed;
  final String image;
  final int status;
  final String createdAt;
  final String updatedAt;

  UserData({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    this.emailVerifiedAt,
    this.googleToken,
    required this.type,
    required this.confirmed,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      emailVerifiedAt: json['email_verified_at'],
      googleToken: json['google_token'],
      type: json['type'],
      confirmed: json['confirmed'],
      image: json['image'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
