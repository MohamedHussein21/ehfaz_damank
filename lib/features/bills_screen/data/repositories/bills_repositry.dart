import 'package:ahfaz_damanak/core/errors/Failure.dart';
import 'package:ahfaz_damanak/core/errors/server_excption.dart';

import 'package:ahfaz_damanak/features/bills_screen/data/models/bills_model.dart';
import 'package:ahfaz_damanak/features/bills_screen/data/models/del_model.dart';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/repositories/Bills_rep.dart';
import '../datasources/biills_data_source.dart';
import '../models/edit_fatora.dart';

class BillsRepositry extends BillsRep {
  final BillsDataSource billsDataSource;

  BillsRepositry(this.billsDataSource);

  @override
  Future<Either<Failure, List<Bill>>> getMyFatoras() async {
    try {
      final result = await billsDataSource.getMyFatoras();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(FailureServer(msg: failure.errorModel.detail));
    }
  }

  @override
  Future<Either<Failure, DeleteModel>> deleteBill(int billId) async {
    try {
      final result = await billsDataSource.deleteBill(billId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(FailureServer(msg: failure.errorModel.detail));
    }
  }

  @override
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
      int orderId) async {
    try {
      final result = await billsDataSource.editFatoura(
          categoryId,
          price,
          name,
          storeName,
          purchaseDate,
          fatoraNumber,
          image,
          daman,
          damanReminder,
          damanDate,
          notes,
          orderId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(FailureServer(msg: failure.errorModel.detail));
    }
  }
}
