import 'package:ahfaz_damanak/features/login/data/models/user_model.dart';
import 'package:ahfaz_damanak/features/register/domain/entities/register.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../../register/data/models/register_model.dart';
import '../../data/models/changePasswordModel.dart';
import '../../data/models/forgetPassModel.dart';
import '../../data/models/sentcodeMoadel.dart';
import '../repositories/login_repositery.dart';

class LoginUseCase {
  final BaseLoginRepository baseAuthRepository;

  LoginUseCase(this.baseAuthRepository);

  Future<Either<Failure, AuthResponse>> execute(
      {required String phone,
      required String password,
      required String googleToken}) async {
    return await baseAuthRepository.userLogin(phone, password, googleToken);
  }

  Future<Either<Failure, RegisterModel>> sendVerifyForgetPasswordEmail({
    required String email,
  }) async {
    return await baseAuthRepository.sendVerifyForgetPasswordEmail(
      email: email,
    );
  }

  Future<Either<Failure, VerifyResponseModel>> changePassword({
    required String password,
    required String confirmPassword,
    required String email,
    required String code,
  }) async {
    return await baseAuthRepository.changePassword(
      password: password,
      confirmPassword: confirmPassword,
      email: email,
      code: code,
    );
  }

  Future<Either<Failure, SentModel>> verifyForgetPassword({
    required String email,
    required String code,
  }) async {
    return await baseAuthRepository.verifyForgetPassword(
      email: email,
      code: code,
    );
  }
}
