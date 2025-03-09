import 'package:dio/dio.dart';

import '../../../../core/errors/server_excption.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/error_model.dart';
import '../models/user_model.dart';

abstract class BaseRemoteDataSource {
  Future<UserModel> userLogin({
    required String email,
    required String password,
  });
}

class RemoteDataSource extends BaseRemoteDataSource {
  @override
  Future<UserModel> userLogin({
    required String email,
    required String password,
  }) async {
    final response = await Dio().post(ApiConstant.login,
        options: Options(
          headers: ApiConstant.headers,
        ),
        data: {
          'email': email,
          'password': password,
        });
    print(response);
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data['data']);
    } else {
      throw ServerException(errorModel: ErrorModel.fromJson(response.data));
    }
  }
}
