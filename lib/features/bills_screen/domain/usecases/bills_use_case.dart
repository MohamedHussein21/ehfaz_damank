import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../data/models/bills_model.dart';
import '../../data/models/del_model.dart';
import '../repositories/Bills_rep.dart';

class BillsUseCase {
  final BillsRep repository;

  BillsUseCase(this.repository);

  Future<Either<Failure, List<Bill>>> execute() => repository.getMyFatoras();

  Future<Either<Failure, DeleteModel>> deleteBill({required int id}) =>
      repository.deleteBill(id);

  Future<Either<Failure, List<Bill>>> editBill() => repository.getMyFatoras();
}
