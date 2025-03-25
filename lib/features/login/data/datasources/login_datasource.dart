import 'dart:developer';
import 'package:dio/dio.dart';

import '../../../../core/errors/server_excption.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/error_model.dart';
import '../models/user_model.dart';

abstract class BaseRemoteDataSource {
  Future<AuthResponse> userLogin({
    required String phone,
    required String password,
  });
}

class RemoteDataSource extends BaseRemoteDataSource {
  final Dio dio;

  RemoteDataSource(this.dio);

  @override
  Future<AuthResponse> userLogin({
    required String phone,
    required String password,
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
        },
      );

      log('Response: ${response.data}');

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
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
