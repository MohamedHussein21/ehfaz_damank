import 'dart:developer';

import 'package:ahfaz_damanak/features/profile_screen/data/models/profile_model.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/server_excption.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/error_model.dart';
import '../../../../core/utils/constant.dart';

abstract class ProfileDatasource {
  Future<Profile> getUser();

  Future<EditProfileModel> editProfile({
    required String phone,
    required String name,
  });

  Future<EditProfileModel> deleteUser({required String userId});
}

class ProfileDataSourceImpl implements ProfileDatasource {
  @override
  Future<Profile> getUser() async {
    try {
      final response = await Dio().get(ApiConstant.profile,
          options: Options(
            headers: { 'Accept': 'application/json',
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',}
            ));
      if (response.statusCode == 200) {
        log(response.data.toString());
        return Profile.fromJson(response.data['data']['profile']);
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
  Future<EditProfileModel> editProfile({
    required String phone,
    required String name,
  }) async {
    try {
      final response = await Dio().post(ApiConstant.updateProfile,
          options: Options(
            headers:{
               'Accept': 'application/json',
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
            }
            ),
          data: {
            'phone': phone,
            'name': name,
          });
      if (response.statusCode == 200) {
        return EditProfileModel.fromJson(response.data);
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

  @override
  Future<EditProfileModel> deleteUser({required String userId}) async {
    try {
      final response = await Dio().post(ApiConstant.delUser,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          ),
          data: {
            'user_id': userId,
          });
      if (response.statusCode == 200) {
        log(response.data['data'].toString());
        return EditProfileModel.fromJson(response.data);
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
