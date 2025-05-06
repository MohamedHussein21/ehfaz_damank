import 'dart:developer';

import 'package:ahfaz_damanak/features/add_fatoura/data/datasources/addFatoura_dataSource.dart';
import 'package:ahfaz_damanak/features/add_fatoura/data/repositories/add_fatoura_repository.dart';
import 'package:ahfaz_damanak/features/add_fatoura/domain/repositories/addFatoraRepo.dart';
import 'package:ahfaz_damanak/features/add_fatoura/domain/usecases/add_fatoura_userCase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/add_fatoura_model.dart';
import '../../data/models/categoris_model.dart';
import '../../data/models/qr_model.dart';

part 'add_fatoura_state.dart';

class AddFatouraCubit extends Cubit<AddFatouraState> {
  AddFatouraCubit() : super(AddFatouraInitial());

  static AddFatouraCubit get(context) => BlocProvider.of(context);
  FatoraModel? fatoraModel;
  QrModel? qrModel;
  List<CategoryModel>? categoryModel;
  Future<void> addFatoura({
    required int categoryd,
    required String name,
    required String storeName,
    required String purchaseDate,
    required String fatoraNumber,
    required int daman,
    required String damanDate,
    required String notes,
    required double price,
    required int reminder,
    XFile? image,
  }) async {
    emit(AddFatouraLoading());
    AddFatouraRemoteDataSource addFatouraRemoteDataSource =
        AddFatouraRemoteDataSource();
    Addfatorarepo addfatorarepo =
        AddFatouraRepository(addFatouraRemoteDataSource);
    final result = await AddFatouraUsercase(addfatorarepo).addFatoura(
        categoryd: categoryd,
        name: name,
        storeName: storeName,
        purchaseDate: purchaseDate,
        fatoraNumber: fatoraNumber,
        daman: daman,
        damanDate: damanDate,
        notes: notes,
        price: price,
        reminder: reminder,
        image: image ?? XFile(''));
    result.fold((l) => emit(AddFatouraError(l.msg)), (r) {
      emit(AddFatouraSuccess(r));
      fatoraModel = r;
    });
    log('addFatoura: $fatoraModel');
  }

  void addFromQr(int receiverId, int orderId) async {
    emit(AddFatouraQrLoading());
    AddFatouraRemoteDataSource addFatouraRemoteDataSource =
        AddFatouraRemoteDataSource();
    Addfatorarepo addfatorarepo =
        AddFatouraRepository(addFatouraRemoteDataSource);
    final result =
        await AddFatouraUsercase(addfatorarepo).addFromQr(receiverId, orderId);
    result.fold((l) => emit(AddFatouraQrError()), (r) {
      emit(AddFatouraQrSuccess(r));
      qrModel = r;
    });
    log('addFatoura: $fatoraModel');
  }

  // void deletFatoura({ required int id}) async {
  //   emit(RegisterScreenVerifyLoading());
  //   BaseRegisterRemoteDataSource baseRemoteDataSource =
  //       RegisterRemoteDataSource();
  //   BaseRegisterRepository baseAuthRepository =
  //       RegisterRepo(baseRemoteDataSource);
  //   final result = await RegisterUsecase(baseAuthRepository).verify(
  //     phone: phone,
  //     otp: otp,
  //   );
  //   result.fold((l) => emit(RegisterScreenVerifyError(l.msg)), (r) {
  //     emit(RegisterScreenVerifySuccess(r, r.apiToken ?? ''));
  //     verifyResponse = r.data;
  //   });
  //   log('RegisterCubit: userVerify: $userModel');
  // }
  void getCategoris() async {
    emit(GetCategoriesLoading());
    AddFatouraRemoteDataSource addFatouraRemoteDataSource =
        AddFatouraRemoteDataSource();
    Addfatorarepo addfatorarepo =
        AddFatouraRepository(addFatouraRemoteDataSource);
    final result = await AddFatouraUsercase(addfatorarepo).getCategoris();
    result.fold((l) => emit(GetCategoriesError()), (r) {
      emit(GetCategoriesSuccess(r));
      categoryModel = r;
    });
  }
}
