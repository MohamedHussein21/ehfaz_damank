import 'dart:developer';

import 'package:ahfaz_damanak/features/profile_screen/data/models/profile_model.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/server_excption.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/error_model.dart';

abstract class ProfileDatasource {
  Future<Profile> getUser();

  Future<Profile> editProfile({
    required String phoneNumber,
    required String userId,
    required String name,
  });
}

class ProfileDataSourceImpl implements ProfileDatasource {
  @override
  Future<Profile> getUser() async {
    try {
      final response = await Dio().get(ApiConstant.profile,
          options: Options(headers: ApiConstant.headers));
      if (response.statusCode == 200) {
        log(response.data.toString());
        return Profile.fromJson(response.data);
      } else {
        throw ServerException(errorModel: ErrorModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      log(e.message.toString());
      log(e.response!.data.toString());

      if (e.response != null) {
        throw ServerException(
            errorModel: ErrorModel.fromJson(e.response?.data));
      } else {
        log(e.message.toString());

        throw ServerException(
            errorModel: ErrorModel.fromJson(e.response?.data));
      }
    }
  }

  @override
  Future<Profile> editProfile({
    required String phoneNumber,
    required String userId,
    required String name,
  }) async {
    try {
      final response = await Dio().put(ApiConstant.updateProfile,
          options: Options(headers: ApiConstant.headers),
          data: {
            'phone': phoneNumber,
            'name': name,
          });
      if (response.statusCode == 200) {
        return Profile.fromJson(response.data);
      } else {
        throw ServerException(errorModel: ErrorModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
            errorModel: ErrorModel.fromJson(e.response?.data));
      } else {
        throw ServerException(
            errorModel: ErrorModel.fromJson(e.response?.data));
      }
    }
  }
}
