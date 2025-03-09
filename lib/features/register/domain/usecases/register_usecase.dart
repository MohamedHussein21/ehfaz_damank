import 'package:ahfaz_damanak/features/login/data/models/user_model.dart';
import 'package:ahfaz_damanak/features/register/domain/repositories/register_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';

class RegisterUsecase {
  final BaseRegisterRepository baseRegisterRepository;

  RegisterUsecase(this.baseRegisterRepository);

  Future<Either<Failure, UserModel>> execute(
      {required String name,
      required String phone,
      required String password}) async {
    return await baseRegisterRepository.userRegister(name, phone, password);
  }
}
