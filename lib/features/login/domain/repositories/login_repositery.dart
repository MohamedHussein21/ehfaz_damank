import 'package:ahfaz_damanak/features/login/data/models/user_model.dart';
import 'package:ahfaz_damanak/features/register/data/models/register_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../data/models/changePasswordModel.dart';
import '../../data/models/forgetPassModel.dart';
import '../../data/models/sentcodeMoadel.dart';

abstract class BaseLoginRepository {
  Future<Either<Failure, AuthResponse>> userLogin(
      String phone, String password, String googleToken);

  Future<Either<Failure, VerifyResponseModel>> changePassword(
      {required String password,
      required String confirmPassword,
      required String email,
      required String code});

  Future<Either<Failure, RegisterModel>> sendVerifyForgetPasswordEmail({
    required String email,
  });

  Future<Either<Failure, SentModel>> verifyForgetPassword({
    required String email,
    required String code,
  });
}
