import 'package:ahfaz_damanak/features/profile_screen/domain/repositories/profile_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../../../core/errors/server_excption.dart';
import '../datasources/profile_dataSource.dart';
import '../models/profile_model.dart';

class ProfilRepository extends ProfileRepo {
  final ProfileDatasource profileDatasource;

  ProfilRepository(this.profileDatasource);
  @override
  Future<Either<Failure, EditProfileModel>> editProfile({
    required String phone,
    required String name,
  }) async {
    final result = await profileDatasource.editProfile(
      phone: phone,
      name: name,
    );
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(FailureServer(failure.errorModel.data,
          msg: failure.errorModel.detail));
    }
  }

  @override
  Future<Either<Failure, Profile>> getUser() async {
    final result = await profileDatasource.getUser();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(FailureServer(failure.errorModel.data,
          msg: failure.errorModel.detail));
    }
  }

  @override
  Future<Either<Failure, EditProfileModel>> deleteUser(
      {required String userId}) async {
    final result = await profileDatasource.deleteUser(userId: userId);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(FailureServer(failure.errorModel.data,
          msg: failure.errorModel.detail));
    }
  }
}
