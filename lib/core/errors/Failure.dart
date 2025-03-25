import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String msg;

  const Failure({required this.msg});
  @override
  List<Object> get props => [msg];
}

class FailureServer extends Failure {
  const FailureServer({required super.msg});
}

class DataBaseFailure extends Failure {
  const DataBaseFailure({required super.msg});
}
