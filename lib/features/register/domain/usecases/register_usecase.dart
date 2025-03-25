import 'package:ahfaz_damanak/features/login/data/models/user_model.dart';
import 'package:ahfaz_damanak/features/register/domain/repositories/register_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../../login/data/models/verify_model.dart';
import '../../data/models/register_model.dart';

class RegisterUsecase {
  final BaseRegisterRepository baseRegisterRepository;

  RegisterUsecase(this.baseRegisterRepository);

  Future<Either<Failure, RegisterModel>> execute(
      {required String name,
      required String phone,
      required String password,
      required String passwordConfirmation}) async {
    return await baseRegisterRepository.userRegister(
        name, phone, password, passwordConfirmation);
  }

  Future<Either<Failure, VerifyResponse>> verify(
      {required String phone, required int otp}) async {
    return await baseRegisterRepository.userVerify(phone, otp);
  }
}
