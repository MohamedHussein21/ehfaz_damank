import 'dart:developer';

import 'package:ahfaz_damanak/core/helper/cash_helper.dart'; // Keep for backwards compatibility
import 'package:ahfaz_damanak/core/storage/hive_helper.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/features/login/data/models/user_model.dart';
import 'package:ahfaz_damanak/features/login/data/repositories/login_repo.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/server_excption.dart';
import '../../../register/data/models/register_model.dart';
import '../../data/datasources/login_datasource.dart';
import '../../data/models/changePasswordModel.dart';
import '../../data/models/forgetPassModel.dart';
import '../../data/models/sentcodeMoadel.dart';
import '../../domain/repositories/login_repositery.dart';
import '../../domain/usecases/login_use_case.dart';
import '../pages/login_screen.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  UserData? userModel;

  /// Clears existing user data before login
  /// Returns true if successful, false otherwise

  void userLogin({
    required String phone,
    required String password,
    required String googleToken,
  }) async {
    emit(LoginLoading());

    try {
      // First step: clear any existing user data
      emit(LoginClearingData());
      userModel = null;

      BaseRemoteDataSource baseRemoteDataSource = RemoteDataSource(Dio());
      BaseLoginRepository baseAuthRepository = LoginRepo(baseRemoteDataSource);

      final result = await LoginUseCase(baseAuthRepository)
          .execute(phone: phone, password: password, googleToken: googleToken);

      await result.fold(
        (failure) async {
          log("Login Error: ${failure.msg} -}");

          final errorMessage = failure.msg;
          emit(LoginError(errorMessage));
        },
        (success) async {
          userModel = success.data;
          Constants.token = success.apiToken;
          Constants.userId = userModel?.id;

          final saveSuccess = await _saveUserData(success);

          if (saveSuccess) {
            emit(LoginSuccess(success, success.apiToken));
          } else {
            emit(LoginError("Failed to save user data. Please try again."));
          }
        },
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;

      log("Dio Error: ${e.message}");
      log("Full Response Data: ${e.response?.data}");

      final errorMessage = errorData is Map
          ? (errorData['data']?.toString() ??
              errorData['msg']?.toString() ??
              "حدث خطأ في الاتصال")
          : "حدث خطأ في الاتصال بالخادم";

      emit(LoginError(errorMessage));
    } catch (e) {
      if (e is ServerException) {
        log("ServerException: ${e.errorModel.toString()}  ");
        emit(LoginError(e.errorModel?.toString() ?? ''));
      } else {
        log("Unexpected Login Error: ${e.toString()}");
        emit(LoginError('حدث خطأ غير متوقع، حاول مرة أخرى لاحقًا.'));
      }
    }
  }

  /// Save user data to storage
  /// Returns true if successful, false otherwise
  Future<bool> _saveUserData(AuthResponse authResponse) async {
    try {
      // Save to HiveHelper
      final apiToken = authResponse.apiToken;
      final userId = authResponse.data.id;
      Constants.token = apiToken;
      Constants.userId = userId;
      log("Saving user data: userId=$userId, token=${apiToken.substring(0, 10)}...");

      // Use the type-safe auth save method
      final hiveSuccess = await HiveHelper.saveAuth(
        apiToken: apiToken,
        userId: userId,
      );

      // Also save to CashHelper for backward compatibility
      final cashSuccessToken =
          await CashHelper.saveData(key: 'api_token', value: apiToken);
      final cashSuccessUserId =
          await CashHelper.saveData(key: 'user_id', value: userId);

      // Verify data was saved correctly
      final success = hiveSuccess && cashSuccessToken && cashSuccessUserId;

      if (!success) {
        log("WARNING: Failed to save user data to storage");
        return false;
      }

      log("User data saved successfully");
      return true;
    } catch (e) {
      log("Error saving user data: $e");
      return false;
    }
  }

  /// Logs out the current user by clearing stored data
  /// Emits LoggedOut state with success or error information
  Future<void> logout(BuildContext context) async {
    emit(LoginClearingData());
    await HiveHelper.logout();
    await CashHelper.logout();
    Constants.token = null;
    Constants.userId = null;
    userModel = null;
    emit(const LoggedOut(success: true));
    log("Logout completed successfully");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> changePassword({
    required String password,
    required String confirmPassword,
    required String phone,
    required String code,
  }) async {
    emit(ChangePasswordLoading());
    BaseRemoteDataSource baseRemoteDataSource = RemoteDataSource(Dio());
    BaseLoginRepository baseAuthRepository = LoginRepo(baseRemoteDataSource);

    final result = await LoginUseCase(baseAuthRepository).changePassword(
      password: password,
      confirmPassword: confirmPassword,
      phone: phone,
      code: code,
    );

    await result.fold(
      (failure) async {
        emit(ChangePasswordError(failure.msg));
      },
      (success) async {
        emit(ChangePasswordSuccess(success));
      },
    );
  }

  Future<void> verifyForgetPassword({
    required String phone,
    required String code,
  }) async {
    emit(VerifyForgetPasswordLoading());
    BaseRemoteDataSource baseRemoteDataSource = RemoteDataSource(Dio());
    BaseLoginRepository baseAuthRepository = LoginRepo(baseRemoteDataSource);

    final result = await LoginUseCase(baseAuthRepository).verifyForgetPassword(
      phone: phone,
      code: code,
    );

    await result.fold(
      (failure) async {
        emit(VerifyForgetPasswordError(failure.msg));
      },
      (success) async {
        emit(VerifyForgetPasswordSuccess(success));
      },
    );
  }

  Future<void> sentVerifyForgetPassword({required String phone}) async {
    emit(SendVerifyForgetPasswordEmailLoading());
    BaseRemoteDataSource baseRemoteDataSource = RemoteDataSource(Dio());
    BaseLoginRepository baseAuthRepository = LoginRepo(baseRemoteDataSource);

    try {
      final result = await LoginUseCase(baseAuthRepository)
          .sendVerifyForgetPasswordEmail(phone: phone);

      await result.fold(
        (failure) async {
          emit(SendVerifyForgetPasswordEmailError(failure.msg));
        },
        (success) async {
          emit(SendVerifyForgetPasswordEmailSuccess(success));
        },
      );
    } catch (e) {
      emit(SendVerifyForgetPasswordEmailError("يرجي التاكد من  رقم الهاتف "));
    }
  }

  bool isShowPass = false;
  bool isShowConfirmPass = false;

  IconData suffix = Icons.visibility_outlined;
  IconData suffixConfirm = Icons.visibility_outlined;

  void changePassVisibility() {
    isShowPass = !isShowPass;
    suffix =
        isShowPass ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(ChangePasswordVisibilityState());
  }

  void changeConfirmPassVisibility() {
    isShowConfirmPass = !isShowConfirmPass;
    suffixConfirm = isShowConfirmPass
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;
    emit(ChangePasswordVisibilityState());
  }
}
