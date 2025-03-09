import 'package:ahfaz_damanak/features/login/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../repositories/login_repositery.dart';

class LoginUseCase {
  final BaseLoginRepository baseAuthRepository;

  LoginUseCase(this.baseAuthRepository);

  Future<Either<Failure, UserModel>> execute(
      {required String email, required String password}) async {
    return await baseAuthRepository.userLogin(email, password);
  }
}
