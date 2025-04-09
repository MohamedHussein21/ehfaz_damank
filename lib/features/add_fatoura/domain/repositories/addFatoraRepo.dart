import 'package:ahfaz_damanak/features/add_fatoura/data/models/add_fatoura_model.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/Failure.dart';
import '../../data/models/qr_model.dart';

abstract class Addfatorarepo {
  Future<Either<Failure, FatoraModel>> addFatoura(
      int categoryd,
      String name,
      String storeName,
      String purchaseDate,
      String fatoraNumber,
      int daman,
      String damanDate,
      String notes,
      int price,
      int reminder,
      XFile image);

   Future<Either<Failure, QrModel>> addFromQr(int receiverId , int orderId);
}
