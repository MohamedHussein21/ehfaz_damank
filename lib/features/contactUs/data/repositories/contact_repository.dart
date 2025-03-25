import 'package:ahfaz_damanak/core/errors/Failure.dart';
import 'package:ahfaz_damanak/features/contactUs/data/datasources/contact_dataSource.dart';
import 'package:ahfaz_damanak/features/contactUs/data/models/contact_model.dart';
import 'package:ahfaz_damanak/features/contactUs/domain/repositories/contact_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/server_excption.dart';

class ContactRepository extends ContactRepo {
  final ContactRemoteDataSource contactRemoteDataSource;

  ContactRepository({required this.contactRemoteDataSource});
  @override
  Future<Either<Failure, ContactModel>> sendMessage(
      {required String email,
      required String phone,
      required String content}) async {
    final result = await contactRemoteDataSource.sendMessage(
        email: email, phone: phone, content: content);

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(FailureServer(msg: failure.errorModel.detail));
    }
  }
}
