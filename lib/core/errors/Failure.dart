import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String massage;

  const Failure({required this.massage});
  @override
  List<Object> get props => [massage];
}

class FailureServer extends Failure {
  const FailureServer({required super.massage});
}

class DataBaseFailure extends Failure {
  const DataBaseFailure({required super.massage});
}
