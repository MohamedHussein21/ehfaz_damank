import 'package:dio/dio.dart';

import '../../../../core/errors/server_excption.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/error_model.dart';
import '../../../login/data/models/user_model.dart';

abstract class BaseRegisterRemoteDataSource {
  Future<UserModel> userRegister({
    required String name,
    required String phone,
    required String password,
  });
}

class RegisterRemoteDataSource extends BaseRegisterRemoteDataSource {
  @override
  Future<UserModel> userRegister({
    required String name,
    required String phone,
    required String password,
  }) async {
    final response = await Dio().post(ApiConstant.signUp,
        options: Options(
          headers: ApiConstant.headers,
        ),
        data: {
          'name': name,
          'phone': phone,
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
