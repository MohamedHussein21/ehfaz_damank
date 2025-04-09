class EditFatoraModel {
  final String msg;
  final String data;

  EditFatoraModel({required this.msg, required this.data});

  factory EditFatoraModel.fromJson(Map<String, dynamic> json) {
    return EditFatoraModel(
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
