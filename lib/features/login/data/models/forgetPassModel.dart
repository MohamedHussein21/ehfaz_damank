class Forgetpassmodel {
  final String msg;
  final String data;

  Forgetpassmodel({
    required this.msg,
    required this.data,
  });

  factory Forgetpassmodel.fromJson(Map<String, dynamic> json) {
    return Forgetpassmodel(
      msg: json['msg'],
      data: json['data'],
    );
  }
}
