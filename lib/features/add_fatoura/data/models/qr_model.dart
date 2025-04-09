class QrModel {
  final String msg;
  final String data;

  QrModel({required this.msg, required this.data});

  factory QrModel.fromJson(Map<String, dynamic> json) {
    return QrModel(
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
