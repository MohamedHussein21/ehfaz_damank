class VerifyResponse {
  final String msg;
  final String apiToken;
  final UserModel data;

  VerifyResponse({
    required this.msg,
    required this.apiToken,
    required this.data,
  });

  factory VerifyResponse.fromJson(Map<String, dynamic> json) {
    return VerifyResponse(
      msg: json['msg'],
      apiToken: json['api_token'],
      data: UserModel.fromJson(json['data']),
    );
  }
}

class UserModel {
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

  UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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
