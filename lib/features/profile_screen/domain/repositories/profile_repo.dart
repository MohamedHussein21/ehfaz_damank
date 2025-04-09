import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../data/models/profile_model.dart';

abstract class ProfileRepo {
  Future<Either<Failure, EditProfileModel>> editProfile({
    required String phone,
    required String name,
  });

  Future<Either<Failure, Profile>> getUser();

  Future<Either<Failure, EditProfileModel>> deleteUser({required String userId});
}
