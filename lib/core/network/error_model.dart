import 'package:equatable/equatable.dart';

class ErrorModel extends Equatable {
  final String detail;

  const ErrorModel(
      {
        required this.detail});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      detail: json['detail'],
    );
  }

  @override
  List<Object?> get props => [
    detail,
  ];
}