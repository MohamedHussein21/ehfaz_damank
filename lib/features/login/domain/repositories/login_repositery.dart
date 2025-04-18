import 'package:ahfaz_damanak/features/login/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';

abstract class BaseLoginRepository {
  Future<Either<Failure, AuthResponse>> userLogin(
      String phone, String password, String googleToken);
}
