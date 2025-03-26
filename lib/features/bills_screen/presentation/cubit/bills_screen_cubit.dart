import 'package:ahfaz_damanak/features/bills_screen/data/models/edit_fatora.dart';
import 'package:ahfaz_damanak/features/bills_screen/domain/repositories/Bills_rep.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

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
  EditFatouraResponseModel? editModel;
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

  void editBill(
      {required int categoryId,
      required int price,
      required String name,
      required String storeName,
      required String purchaseDate,
      required String fatoraNumber,
      required XFile image,
      required int daman,
      required int damanReminder,
      required String damanDate,
      required String notes,
      required int orderId}) async {
    emit(EditFatouraLouding());
    BillsDataSource billsDataSource = BillsDataSourceImpl(Dio());
    BillsRep billsRep = BillsRepositry(billsDataSource);
    final result = await BillsUseCase(billsRep).editBill(
        categoryId: categoryId,
        price: price,
        name: name,
        storeName: storeName,
        purchaseDate: purchaseDate,
        fatoraNumber: fatoraNumber,
        image: image,
        daman: daman,
        damanReminder: damanReminder,
        damanDate: damanDate,
        notes: notes,
        orderId: orderId);
    result.fold(
      (l) => emit(EditFatouraError(l.msg)),
      (r) {
        editModel = r;
        emit(EditFatouraSuccus(editFatouraResponseModel: r));
      },
    );
  }
}
