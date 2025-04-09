import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../../login/data/models/verify_model.dart';
import '../../data/models/register_model.dart';

abstract class BaseRegisterRepository {
  Future<Either<Failure, RegisterModel>> userRegister(String name, String phone,
      String password, String passwordConfirmation, String googleToken);

  Future<Either<Failure, VerifyResponse>> userVerify(String phone, int otp);
}
