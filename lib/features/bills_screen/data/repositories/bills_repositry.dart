import 'package:ahfaz_damanak/core/errors/Failure.dart';
import 'package:ahfaz_damanak/core/errors/server_excption.dart';

import 'package:ahfaz_damanak/features/bills_screen/data/models/bills_model.dart';
import 'package:ahfaz_damanak/features/bills_screen/data/models/del_model.dart';

import 'package:dartz/dartz.dart';

import '../../domain/repositories/Bills_rep.dart';
import '../datasources/biills_data_source.dart';

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

  // @override
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
  //     int orderId) {
  //         try {
  //     final result = await billsDataSource.deleteBill(billId);
  //     return Right(result);
  //   } on ServerException catch (failure) {
  //     return Left(FailureServer(msg: failure.errorModel.detail));
  //   }
  //     }
}
