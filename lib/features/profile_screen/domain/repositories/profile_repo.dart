import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../data/models/profile_model.dart';

abstract class ProfileRepo {
  Future<Either<Failure, Profile>> editProfile({
    required String phoneNumber,
    required String userId,
    required String name,
  });

  Future<Either<Failure, Profile>> getUser();
}
