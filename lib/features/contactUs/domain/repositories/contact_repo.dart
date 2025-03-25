import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../data/models/contact_model.dart';

abstract class ContactRepo {
  Future<Either<Failure, ContactModel>> sendMessage(
      {required String email, required String phone, required String content});
}
