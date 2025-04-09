import 'package:ahfaz_damanak/features/login/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../../../core/errors/server_excption.dart';
import '../../domain/repositories/login_repositery.dart';
import '../datasources/login_datasource.dart';

class LoginRepo extends BaseLoginRepository {
  final BaseRemoteDataSource baseRemoteDataSource;

  LoginRepo(this.baseRemoteDataSource);

  @override
  Future<Either<Failure, AuthResponse>> userLogin(
      String phone, String password, String googleToken) async {
    final result = await baseRemoteDataSource.userLogin(
        phone: phone, password: password, googleToken: googleToken);

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(FailureServer(msg: failure.errorModel.detail));
    }
  }
}
