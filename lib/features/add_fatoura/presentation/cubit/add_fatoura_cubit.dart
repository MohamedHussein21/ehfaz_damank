import 'dart:developer';

import 'package:ahfaz_damanak/features/add_fatoura/data/datasources/addFatoura_dataSource.dart';
import 'package:ahfaz_damanak/features/add_fatoura/data/repositories/add_fatoura_repository.dart';
import 'package:ahfaz_damanak/features/add_fatoura/domain/repositories/addFatoraRepo.dart';
import 'package:ahfaz_damanak/features/add_fatoura/domain/usecases/add_fatoura_userCase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/add_fatoura_model.dart';

part 'add_fatoura_state.dart';

class AddFatouraCubit extends Cubit<AddFatouraState> {
  AddFatouraCubit() : super(AddFatouraInitial());

  static AddFatouraCubit get(context) => BlocProvider.of(context);

  FatoraModel? userModel;
  void addFatoura(
      {required int categoryd,
      required String name,
      required String storeName,
      required String purchaseDate,
      required String fatoraNumber,
      required int daman,
      required String damanDate,
      required String notes,
      required int price,
      required int reminder,
      required XFile image}) async {
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
        image: image);
    result.fold((l) => emit(AddFatouraError(l.msg)), (r) {
      emit(AddFatouraSuccess(r));
      userModel = r;
    });
    log('addFatoura: $userModel');
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
}
