import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/Failure.dart';
import '../../data/models/bills_model.dart';
import '../../data/models/del_model.dart';
import '../../data/models/edit_fatora.dart';

abstract class BillsRep {
  Future<Either<Failure, List<Bill>>> getMyFatoras();
  Future<Either<Failure, DeleteModel>> deleteBill(int billId);
  Future<Either<Failure, EditFatouraResponseModel>> editFatoura(
      int categoryId,
      int price,
      String name,
      String storeName,
      String purchaseDate,
      String fatoraNumber,
      XFile image,
      int daman,
      int damanReminder,
      String damanDate,
      String notes,
      int orderId);
}
