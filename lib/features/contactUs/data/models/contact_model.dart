class ContactModel {
  final String msg;
  final String data;

  ContactModel({required this.msg, required this.data});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      msg: json['msg'] ?? '',
      data: json['data'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'data': data,
    };
  }
}
