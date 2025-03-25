import 'dart:developer';
import 'package:dio/dio.dart';

import '../../../../core/errors/server_excption.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/error_model.dart';
import '../../../login/data/models/user_model.dart';
import '../../../login/data/models/verify_model.dart';
import '../models/register_model.dart';

abstract class BaseRegisterRemoteDataSource {
  Future<RegisterModel> userRegister({
    required String name,
    required String phone,
    required String password,
    required String passwordConfirmation,
  });

  Future<VerifyResponse> userVerify({
    required String phone,
    required int otp,
  });
}

class RegisterRemoteDataSource extends BaseRegisterRemoteDataSource {
  @override
  Future<RegisterModel> userRegister({
    required String name,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await Dio().post(
        ApiConstant.signUp,
        options: Options(
          headers: ApiConstant.headers,
          validateStatus: (status) => status! < 500,
        ),
        data: {
          'name': name,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      log(response.data.toString());

      if (response.statusCode == 200) {
        return RegisterModel.fromJson(response.data);
      } else {
        throw ServerException(errorModel: ErrorModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        log('Dio Error: ${e.response?.statusCode} - ${e.response?.data}');
        throw ServerException(
            errorModel: ErrorModel.fromJson(e.response?.data));
      } else {
        log('Dio Error: ${e.message}');
        throw ServerException(
            errorModel: ErrorModel(detail: 'Unexpected error occurred'));
      }
    } catch (e) {
      log('Unexpected Error: $e');
      throw ServerException(
          errorModel: ErrorModel(detail: 'Something went wrong!'));
    }
  }

  @override
  Future<VerifyResponse> userVerify(
      {required String phone, required int otp}) async {
    try {
      final response = await Dio().post(
        ApiConstant.verify,
        options: Options(
          headers: ApiConstant.headers,
          validateStatus: (status) => status! < 500,
        ),
        data: {
          'phone': phone,
          'code': otp,
        },
      );

      log('Response: ${response.data}');
      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        return VerifyResponse.fromJson(response.data);
      } else {
        throw ServerException(errorModel: ErrorModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        log('Dio Error: ${e.response?.statusCode} - ${e.response?.data}');
        throw ServerException(
            errorModel: ErrorModel.fromJson(e.response?.data));
      } else {
        log('Dio Error: ${e.message}');
        throw ServerException(
            errorModel: ErrorModel(detail: 'Unexpected error occurred'));
      }
    } catch (e) {
      log('Unexpected Error: $e');
      throw ServerException(
          errorModel: ErrorModel(detail: 'Something went wrong!'));
    }
  }
}
