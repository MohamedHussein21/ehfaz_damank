import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String msg;
  final String data;

  const Failure(this.data, {required this.msg});
  @override
  List<Object> get props => [msg];
}

class FailureServer extends Failure {
  const FailureServer(
    super.data, {
    required super.msg,
  });
}

class DataBaseFailure extends Failure {
  const DataBaseFailure(super.data, {required super.msg});
}
