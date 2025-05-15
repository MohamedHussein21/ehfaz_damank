import 'package:ahfaz_damanak/features/login/data/models/forgetPassModel.dart';
import 'package:ahfaz_damanak/features/login/data/models/user_model.dart';
import 'package:ahfaz_damanak/features/register/data/models/register_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../../../core/errors/server_excption.dart';
import '../../domain/repositories/login_repositery.dart';
import '../datasources/login_datasource.dart';
import '../models/changePasswordModel.dart';
import '../models/sentcodeMoadel.dart';

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
      final errorData = failure.errorModel?.data;

      return Left(FailureServer(
        failure.errorModel?['data'] ?? 'Unknown error',
        msg: errorData?['msg'] ?? 'Login failed',
      ));
    }
  }

  @override
  Future<Either<Failure, VerifyResponseModel>> changePassword(
      {required String password,
      required String confirmPassword,
      required String phone,
      required String code}) async {
    final result = await baseRemoteDataSource.changePassword(
        password: password,
        confirmPassword: confirmPassword,
        phone: phone,
        code: code);

    try {
      return Right(result);
    } on ServerException catch (failure) {
      final errorData = failure.errorModel?.data;

      return Left(FailureServer(
        failure.errorModel?['data'] ?? 'Unknown error',
        msg: errorData?['msg'] ?? 'Login failed',
      ));
    }
  }

  @override
  Future<Either<Failure, RegisterModel>> sendVerifyForgetPasswordEmail(
      {required String phone}) async {
    final result = await baseRemoteDataSource.sendVerifyForgetPasswordEmail(
      phone: phone,
    );

    try {
      return Right(result);
    } on ServerException catch (failure) {
      final errorData = failure.errorModel?.data;

      return Left(FailureServer(
        failure.errorModel?['data'] ?? 'Unknown error',
        msg: errorData?['msg'] ?? 'Login failed',
      ));
    }
  }

  @override
  Future<Either<Failure, SentModel>> verifyForgetPassword(
      {required String phone, required String code}) async {
    final result = await baseRemoteDataSource.verifyForgetPassword(
        phone: phone, code: code);

    try {
      return Right(result);
    } on ServerException catch (failure) {
      final errorData = failure.errorModel?.data;

      return Left(FailureServer(
        failure.errorModel?['data'] ?? 'Unknown error',
        msg: errorData?['msg'] ?? 'Login failed',
      ));
    }
  }
}
