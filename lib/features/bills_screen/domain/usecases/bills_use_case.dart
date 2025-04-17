import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/Failure.dart';
import '../../data/models/bills_model.dart';
import '../../data/models/del_model.dart';
import '../../data/models/edit_fatora.dart';
import '../repositories/Bills_rep.dart';

class BillsUseCase {
  final BillsRep repository;

  BillsUseCase(this.repository);

  Future<Either<Failure, List<Bill>>> execute() => repository.getMyFatoras();

  Future<Either<Failure, DeleteModel>> deleteBill({required String id}) =>
      repository.deleteBill(id);

  Future<Either<Failure, EditFatoraModel>> editBill(
          {required int categoryId,
          required int price,
          required String name,
          required String storeName,
          required String purchaseDate,
          required String fatoraNumber,
          required int daman,
          required int damanReminder,
          required String damanDate,
          required String notes,
          required int orderId}) =>
      repository.editFatoura(categoryId, price, name, storeName, purchaseDate,
          fatoraNumber, daman, damanReminder, damanDate, notes, orderId);

  Future<Either<Failure, List<Bill>>> getFilter({
    int? categoryId,
    String? orderBy,
    String? damanOrder,
  }) {
    return repository.getFilter(categoryId, orderBy, damanOrder);
  }
}
