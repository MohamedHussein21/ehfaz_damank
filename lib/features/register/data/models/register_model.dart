class RegisterModel {
  final String msg;
  final String apiToken;
  final int verified;
  final RegisterData data;

  RegisterModel({
    required this.msg,
    required this.verified,
    required this.apiToken,
    required this.data,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      msg: json['msg'],
      verified: json['verifynumber'],
      apiToken: json['api_token'],
      data: RegisterData.fromJson(json['data']),
    );
  }
}

class RegisterData {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String? googleToken;
  final String type;
  final int confirmed;
  final String createdAt;
  final String updatedAt;

  RegisterData({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.googleToken,
    required this.type,
    required this.confirmed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      googleToken: json['google_token'],
      type: json['type'],
      confirmed: json['confirmed'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
