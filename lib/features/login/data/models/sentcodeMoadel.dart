class Sentcodemoadel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? emailVerifiedAt;
  final String? googleToken;
  final String type;
  final int confirmed;
  final String image;
  final int status;
  final String createdAt;
  final String updatedAt;

  Sentcodemoadel({
    required this.id,
    required this.name,
    required this.email,
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

  factory Sentcodemoadel.fromJson(Map<String, dynamic> json) {
    return Sentcodemoadel(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'email_verified_at': emailVerifiedAt,
      'google_token': googleToken,
      'type': type,
      'confirmed': confirmed,
      'image': image,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class SentModel {
  final String msg;
  final String apiToken;
  final Sentcodemoadel data;

  SentModel({
    required this.msg,
    required this.apiToken,
    required this.data,
  });

  factory SentModel.fromJson(Map<String, dynamic> json) {
    return SentModel(
      msg: json['msg'],
      apiToken: json['api_token'],
      data: Sentcodemoadel.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'api_token': apiToken,
      'data': data.toJson(),
    };
  }
}
