import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../data/models/profile_model.dart';
import '../repositories/profile_repo.dart';

class ProfileUserCase {
  final ProfileRepo profileRepo;
  ProfileUserCase(this.profileRepo);

  Future<Either<Failure, Profile>> getUser() async =>
      await profileRepo.getUser();

  Future<Either<Failure, Profile>> editProfile({
    required String phoneNumber,
    required String userId,
    required String name,
  }) async =>
      await profileRepo.editProfile(
        phoneNumber: phoneNumber,
        userId: userId,
        name: name,
      );
}
