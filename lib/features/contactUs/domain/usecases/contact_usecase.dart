import 'package:ahfaz_damanak/core/errors/Failure.dart';
import 'package:ahfaz_damanak/features/contactUs/data/models/contact_model.dart';
import 'package:ahfaz_damanak/features/contactUs/domain/repositories/contact_repo.dart';
import 'package:dartz/dartz.dart';

class ContactUsecase {
  final ContactRepo contactRepo;

  ContactUsecase(this.contactRepo);

  Future<Either<Failure, ContactModel>> sendMessage(
      {required String email,
      required String phone,
      required String content}) async {
    return await contactRepo.sendMessage(
        phone: phone, email: email, content: content);
  }
}
