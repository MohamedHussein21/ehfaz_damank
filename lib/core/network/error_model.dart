import 'package:equatable/equatable.dart';

class ErrorModel extends Equatable {
  final String detail;
  final Map<String, dynamic>? errors;

  const ErrorModel({required this.detail, this.errors});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      detail: 'valid',
      errors: json,
    );
  }

  @override
  List<Object?> get props => [detail, errors];
}
