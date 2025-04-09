
class ServerException implements Exception {
  final dynamic errorModel;

  const ServerException({required this.errorModel});
}

class LocalDataBaseException implements Exception {
  final String massage;

  const LocalDataBaseException({required this.massage});
}
