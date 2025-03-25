import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../data/models/bills_model.dart';
import '../../data/models/del_model.dart';

abstract class BillsRep {
  Future<Either<Failure, List<Bill>>> getMyFatoras();
  Future<Either<Failure, DeleteModel>> deleteBill(int billId);
  // Future<Either<Failure, List<Bill>>> editFatoura(
  //     int categoryId,
  //     int price,
  //     String name,
  //     String storeName,
  //     String purchaseDate,
  //     String fatoraNumber,
  //     String image,
  //     int daman,
  //     int damanReminder,
  //     String damanDate,
  //     String notes,
  //     int orderId);
}
