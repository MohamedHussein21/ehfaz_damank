class UserModel {
  final int id;
  final String name;
  final String phone;
  final String? emailVerifiedAt;
  final String? googleToken;
  final String type;
  final int confirmed;
  final String image;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
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

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        emailVerifiedAt: json['email_verified_at'],
        googleToken: json['google_token'],
        type: json['type'],
        confirmed: json['confirmed'],
        image: json['image'],
        status: json['status'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email_verified_at': emailVerifiedAt,
        'google_token': googleToken,
        'type': type,
        'confirmed': confirmed,
        'image': image,
        'status': status,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

class VerifyResponseModel {
  final String msg;
  final String apiToken;
  final UserModel data;

  VerifyResponseModel({
    required this.msg,
    required this.apiToken,
    required this.data,
  });

  factory VerifyResponseModel.fromJson(Map<String, dynamic> json) =>
      VerifyResponseModel(
        msg: json['msg'],
        apiToken: json['api_token'],
        data: UserModel.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'msg': msg,
        'api_token': apiToken,
        'data': data.toJson(),
      };
}
