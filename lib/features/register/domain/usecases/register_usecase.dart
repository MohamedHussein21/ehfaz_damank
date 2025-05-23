import 'package:ahfaz_damanak/features/register/domain/repositories/register_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../../login/data/models/verify_model.dart';
import '../../data/models/register_model.dart';

class RegisterUsecase {
  final BaseRegisterRepository baseRegisterRepository;

  RegisterUsecase(this.baseRegisterRepository);

  Future<Either<Failure, RegisterModel>> execute({
    required String name,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String googleToken,
  }) async {
    return await baseRegisterRepository.userRegister(
        name, phone, password, passwordConfirmation, googleToken);
  }

  Future<Either<Failure, VerifyResponse>> verify(
      {required String phone, required int code}) async {
    return await baseRegisterRepository.userVerify(phone, code);
  }
}
