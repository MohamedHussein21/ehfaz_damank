import 'package:ahfaz_damanak/features/login/data/models/user_model.dart';
import 'package:ahfaz_damanak/features/register/data/datasources/register_data_source.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../../../core/errors/server_excption.dart';
import '../../../login/data/models/verify_model.dart';
import '../../domain/repositories/register_repository.dart';
import '../models/register_model.dart';

class RegisterRepo extends BaseRegisterRepository {
  final BaseRegisterRemoteDataSource registerRemoteDataSource;

  RegisterRepo(this.registerRemoteDataSource);

  @override
  Future<Either<Failure, RegisterModel>> userRegister(String name, String phone,
      String password, String passwordConfirmation) async {
    final result = await registerRemoteDataSource.userRegister(
        name: name,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation);

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(FailureServer(msg: failure.errorModel.detail));
    }
  }

  @override
  Future<Either<Failure, VerifyResponse>> userVerify(
      String phone, int otp) async {
    final result =
        await registerRemoteDataSource.userVerify(phone: phone, otp: otp);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(FailureServer(msg: failure.errorModel.detail));
    }
  }
}
