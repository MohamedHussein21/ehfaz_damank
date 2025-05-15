import 'dart:developer';
import 'package:ahfaz_damanak/features/login/data/models/forgetPassModel.dart';
import 'package:ahfaz_damanak/features/register/data/models/register_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/server_excption.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/utils/constant.dart';
import '../models/changePasswordModel.dart';
import '../models/sentcodeMoadel.dart';
import '../models/user_model.dart';

abstract class BaseRemoteDataSource {
  Future<AuthResponse> userLogin({
    required String phone,
    required String password,
    required String googleToken,
  });
  Future<VerifyResponseModel> changePassword({
    required String password,
    required String confirmPassword,
    required String phone,
    required String code,
  });
  Future<RegisterModel> sendVerifyForgetPasswordEmail({required String phone});

  Future<SentModel> verifyForgetPassword({
    required String phone,
    required String code,
  });
}

class RemoteDataSource extends BaseRemoteDataSource {
  final Dio dio;

  RemoteDataSource(this.dio);

  @override
  Future<AuthResponse> userLogin({
    required String phone,
    required String password,
    required String googleToken,
  }) async {
    try {
      final response = await dio.post(
        ApiConstant.login,
        options: Options(
          headers: ApiConstant.headers,
          validateStatus: (status) => status! < 500,
        ),
        data: {
          'phone': phone,
          'password': password,
          'google_token': googleToken,
        },
      );

      log('Response: ${response.data}');

      if (response.data['msg'] == 'success') {
        return AuthResponse.fromJson(response.data);
      } else {
        throw ServerException(
          errorModel: response.data['data'],
        );
      }
    } catch (e) {
      log('Login Error: $e');
      rethrow;
    }
  }

  @override
  Future<VerifyResponseModel> changePassword(
      {required String password,
      required String confirmPassword,
      required String phone,
      required String code}) async {
    try {
      final response = await dio.post(
        ApiConstant.rechangepass,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
        data: {
          'new_pass': password,
          'confirm_pass': confirmPassword,
          'phone': phone,
          'code': code
        },
      );

      log('Response: ${response.data}');

      if (response.data['msg'] == 'success') {
        return VerifyResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorModel: response.data,
        );
      }
    } catch (e) {
      log('Login Error: $e');
      rethrow;
    }
  }

  @override
  Future<RegisterModel> sendVerifyForgetPasswordEmail(
      {required String phone}) async {
    try {
      final response = await dio.post(
        ApiConstant.sendVerifyForgetPasswordNum,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'phone': phone,
        },
      );

      log('Response: ${response.data}');

      if (response.data['msg'] == 'success') {
        return RegisterModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorModel: response.data,
        );
      }
    } catch (e) {
      log('Login Error: $e');
      rethrow;
    }
  }

  @override
  Future<SentModel> verifyForgetPassword(
      {required String phone, required String code}) async {
    try {
      log('Code to verify: $code');
      log('Phone number: $phone');
      final response = await dio.post(
        ApiConstant.verifyForgetPassword,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
        data: {'phone': phone, 'code': code},
      );

      log('Response: ${response.data}');

      if (response.data['msg'] == 'success') {
        return SentModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorModel: response.data['data'],
        );
      }
    } catch (e) {
      log('Login Error: $e');
      rethrow;
    }
  }
}
