import 'dart:developer';

import 'package:ahfaz_damanak/features/register/data/models/register_model.dart';
import 'package:ahfaz_damanak/features/register/data/repositories/register_repo.dart';
import 'package:ahfaz_damanak/features/register/domain/usecases/register_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../login/data/models/verify_model.dart';
import '../../data/datasources/register_data_source.dart';
import '../../domain/repositories/register_repository.dart';

part 'register_screen_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterScreenInitial());

  static RegisterCubit get(context) => BlocProvider.of(context);

  RegisterData? userModel;
  UserModel? verifyResponse;

  void userRegister({
    required String name,
    required String phone,
    required String password,
    required String passwordConfirmation,
    String googleToken = '',
  }) async {
    emit(RegisterScreenLoading());
    try {
      BaseRegisterRemoteDataSource baseRemoteDataSource =
          RegisterRemoteDataSource();
      BaseRegisterRepository baseAuthRepository =
          RegisterRepo(baseRemoteDataSource);

      final result = await RegisterUsecase(baseAuthRepository).execute(
        name: name,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        googleToken: googleToken,
      );

      result.fold(
        (l) => emit(RegisterScreenError(l.msg)),
        (r) {
          emit(RegisterScreenSuccess(r));
          userModel = r.data;
          log('RegisterCubit: userRegister: $userModel');
        },
      );
    } catch (e) {
      emit(RegisterScreenError('حدث خطأ غير متوقع، حاول مرة أخرى.'));
      log('RegisterCubit: userRegister error: $e');
    }
  }

  bool rememberMe = false;
  void rememberMeChange(bool value) {
    rememberMe = value;
    emit(RegisterScreenRememberMe(rememberMe));
  }

  void userVerify({required String phone, required int code}) async {
    emit(RegisterScreenVerifyLoading());
    BaseRegisterRemoteDataSource baseRemoteDataSource =
        RegisterRemoteDataSource();
    BaseRegisterRepository baseAuthRepository =
        RegisterRepo(baseRemoteDataSource);
    final result = await RegisterUsecase(baseAuthRepository).verify(
      phone: phone,
      code: code,
    );
    result.fold((l) => emit(RegisterScreenVerifyError(l.msg)), (r) {
      emit(RegisterScreenVerifySuccess(r));
      verifyResponse = r.data;
    });
    log('RegisterCubit: userVerify: $verifyResponse');
  }
}
