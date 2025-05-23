import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../data/models/bills_model.dart';
import '../../data/models/del_model.dart';
import '../../data/models/edit_fatora.dart';

abstract class BillsRep {
  Future<Either<Failure, List<Bill>>> getMyFatoras();
  Future<Either<Failure, DeleteModel>> deleteBill(String billId);
  Future<Either<Failure, EditFatoraModel>> editFatoura(
      int categoryId,
      double price,
      String name,
      String storeName,
      String purchaseDate,
      String fatoraNumber,
      int daman,
      int damanReminder,
      String damanDate,
      String notes,
      int orderId);
  Future<Either<Failure, List<Bill>>> getFilter(
      int? categoryId, String? orderBy, String? damanOrder);
}
