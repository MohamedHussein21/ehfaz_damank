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
    required String googleToken,
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
}
