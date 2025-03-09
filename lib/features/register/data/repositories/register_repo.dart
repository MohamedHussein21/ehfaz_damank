import 'package:ahfaz_damanak/features/login/data/models/user_model.dart';
import 'package:ahfaz_damanak/features/register/data/datasources/register_data_source.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../../../core/errors/server_excption.dart';
import '../../domain/repositories/register_repository.dart';

class RegisterRepo extends BaseRegisterRepository {
  final BaseRegisterRemoteDataSource registerRemoteDataSource;

  RegisterRepo(this.registerRemoteDataSource);

  @override
  Future<Either<Failure, UserModel>> userRegister(
      String name, String phone, String password) async {
    final result = await registerRemoteDataSource.userRegister(
        name: name, phone: phone, password: password);

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(FailureServer(massage: failure.errorModel.detail));
    }
  }
}
