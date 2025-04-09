import 'dart:developer';

import 'package:ahfaz_damanak/features/login/data/models/user_model.dart';
import 'package:ahfaz_damanak/features/login/data/repositories/login_repo.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/login_datasource.dart';
import '../../domain/repositories/login_repositery.dart';
import '../../domain/usecases/login_use_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  UserData? userModel;

  void userLogin({
    required String phone,
    required String password,
    required String googleToken,
  }) async {
    emit(LoginLoading());

    try {
      BaseRemoteDataSource baseRemoteDataSource = RemoteDataSource(Dio());
      BaseLoginRepository baseAuthRepository = LoginRepo(baseRemoteDataSource);

      final result = await LoginUseCase(baseAuthRepository)
          .execute(phone: phone, password: password, googleToken: googleToken);

      result.fold(
        (failure) {
          log("Login Error: ${failure.msg}");
          emit(LoginError(failure.msg));
        },
        (authResponse) {
          emit(LoginSuccess(authResponse, authResponse.apiToken));
          userModel = authResponse.data;
        },
      );
    } catch (e) {
      log("Unexpected Login Error: $e");
      emit(LoginError("حدث خطأ غير متوقع، حاول مرة أخرى."));
    }
  }
}
