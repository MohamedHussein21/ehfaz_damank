import 'package:ahfaz_damanak/features/bills_screen/domain/repositories/Bills_rep.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../data/datasources/biills_data_source.dart';
import '../../data/models/bills_model.dart';
import '../../data/models/del_model.dart';
import '../../data/repositories/bills_repositry.dart';
import '../../domain/usecases/bills_use_case.dart';
import 'bills_screen_state.dart';

class BillsScreenCubit extends Cubit<BillsScreenState> {
  BillsScreenCubit() : super(BillsScreenInitial());

  List<Bill> billsModel = [];
  DeleteModel? deleteModel;
  void getBills() async {
    emit(BillsScreenLoading());
    BillsDataSource billsDataSource = BillsDataSourceImpl(Dio());
    BillsRep billsRep = BillsRepositry(billsDataSource);
    final result = await BillsUseCase(billsRep).execute();
    result.fold(
      (l) => emit(BillsScreenError(l.msg)),
      (r) {
        billsModel = List<Bill>.from(r);
        emit(BillsScreenSuccess(billsModel));
      },
    );
  }

  void deleteBill({required int id}) async {
    emit(BillDeletingLouding());
    BillsDataSource billsDataSource = BillsDataSourceImpl(Dio());
    BillsRep billsRep = BillsRepositry(billsDataSource);
    final result = await BillsUseCase(billsRep).deleteBill(id: id);
    result.fold(
      (l) => emit(BillDeletingError(l.msg)),
      (r) {
        deleteModel = r;
        emit(BillDeletingSuccus(deleteModel: r));
      },
    );
  }
}
