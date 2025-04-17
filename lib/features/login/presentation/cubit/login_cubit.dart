import 'dart:developer';

import 'package:ahfaz_damanak/core/helper/cash_helper.dart'; // Keep for backwards compatibility
import 'package:ahfaz_damanak/core/storage/hive_helper.dart';
import 'package:ahfaz_damanak/core/storage/models/auth_box.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/features/login/data/models/user_model.dart';
import 'package:ahfaz_damanak/features/login/data/repositories/login_repo.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/login_datasource.dart';
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
      // Second step: proceed with login
      BaseRemoteDataSource baseRemoteDataSource = RemoteDataSource(Dio());
      BaseLoginRepository baseAuthRepository = LoginRepo(baseRemoteDataSource);

      final result = await LoginUseCase(baseAuthRepository)
          .execute(phone: phone, password: password, googleToken: googleToken);

      result.fold((failure) {
        log("Login Error: ${failure.msg}");
        emit(LoginError(failure.msg));
        (authResponse) async {
          // userModel = authResponse.data;
          // Constants.token = authResponse?.apiToken;
          // Constants.userId = userModel?.id;
          // // Save user data to storage
          // final saveSuccess = await _saveUserData(authResponse);

          // if (saveSuccess) {
          //   emit(LoginSuccess(authResponse, authResponse.apiToken));
          // } else {
          emit(LoginError("Failed to save user data. Please try again."));
          // }
        };
      }, (success) async {
        userModel = success.data;
        Constants.token = success.apiToken;
        Constants.userId = userModel?.id;
        // Save user data to storage
        final saveSuccess = await _saveUserData(success);

        if (saveSuccess) {
          emit(LoginSuccess(success, success.apiToken));
        } else {
          emit(LoginError("Failed to save user data. Please try again."));
        }
      });
    } catch (e) {
      log("Unexpected Login Error: $e");
      emit(LoginError("حدث خطأ غير متوقع، حاول مرة أخرى."));
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
}
