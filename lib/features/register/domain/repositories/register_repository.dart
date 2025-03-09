import 'package:ahfaz_damanak/features/login/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';

abstract class BaseRegisterRepository {
  Future<Either<Failure, UserModel>> userRegister(
      String name, String phone, String password);
}
