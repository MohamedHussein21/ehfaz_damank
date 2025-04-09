import 'package:ahfaz_damanak/features/add_fatoura/data/datasources/addFatoura_dataSource.dart';
import 'package:ahfaz_damanak/features/add_fatoura/data/models/add_fatoura_model.dart';
import 'package:ahfaz_damanak/features/add_fatoura/domain/repositories/addFatoraRepo.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/Failure.dart';
import '../../../../core/errors/server_excption.dart';
import '../models/qr_model.dart';

class AddFatouraRepository extends Addfatorarepo {
  final AddFatouraRemoteDataSource addFatouraRemoteDataSource;

  AddFatouraRepository(this.addFatouraRemoteDataSource);

  @override
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
      XFile image) async {
    final result = await addFatouraRemoteDataSource.addFatora(
        categoryId: categoryd,
        name: name,
        storeName: storeName,
        purchaseDate: purchaseDate,
        fatoraNumber: fatoraNumber,
        daman: daman,
        damanDate: damanDate,
        notes: notes,
        price: price,
        reminder: reminder,
        image: image);

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(FailureServer(
          msg: failure.errorModel.errors ?? failure.errorModel.detail));
    }
  }

  @override
  Future<Either<Failure, QrModel>> addFromQr(int receiverId , int orderId) async {
    final result = await addFatouraRemoteDataSource.addFromQr( receiverId, orderId);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(FailureServer(msg: failure.errorModel.detail));
    }
  }

  // @override
  // Future<Either<Failure, FatoraModel>> deletFatoura(int id) async {
  //   final result = await addFatouraRemoteDataSource.deleteFatoura(id: id);
  //   try {
  //     return Right(result);
  //   } on ServerException catch (failure) {
  //     return Left(FailureServer(msg: failure.errorModel.detail));
  //   }
  // }
}
