class DeleteModel {
  final String msg;
  final String data;

  DeleteModel({required this.msg, required this.data});

  factory DeleteModel.fromJson(Map<String, dynamic> json) {
    return DeleteModel(
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
