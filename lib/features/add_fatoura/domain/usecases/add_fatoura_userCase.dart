import 'package:ahfaz_damanak/features/add_fatoura/data/models/add_fatoura_model.dart';
import 'package:ahfaz_damanak/features/add_fatoura/domain/repositories/addFatoraRepo.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/Failure.dart';
import '../../data/models/qr_model.dart';

class AddFatouraUsercase {
  final Addfatorarepo addfatorarepo;

  AddFatouraUsercase(this.addfatorarepo);

  Future<Either<Failure, FatoraModel>> addFatoura(
      {required int categoryd,
      required String name,
      required String storeName,
      required String purchaseDate,
      required String fatoraNumber,
      required int daman,
      required String damanDate,
      required String notes,
      required int price,
      required int reminder,
      required XFile image}) async {
    return await addfatorarepo.addFatoura(
        categoryd,
        name,
        storeName,
        purchaseDate,
        fatoraNumber,
        daman,
        damanDate,
        notes,
        price,
        reminder,
        image);
  }
Future<Either<Failure, QrModel>> addFromQr(int receiverId , int orderId) async {
    return await addfatorarepo.addFromQr(receiverId , orderId);
}
  // Future<Either<Failure, FatoraModel>> deleteFatoura({
  //   required int id,
  // }) async {
  //   return await addfatorarepo.deletFatoura(id);
  // }
}
