import 'package:ahfaz_damanak/features/login/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
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
}
