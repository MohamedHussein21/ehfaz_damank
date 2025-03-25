import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/errors/server_excption.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/error_model.dart';
import '../models/contact_model.dart';

abstract class ContactDatasource {
  Future<ContactModel> sendMessage(
      {required String email, required String phone, required String content});
}

class ContactRemoteDataSource implements ContactDatasource {
  @override
  Future<ContactModel> sendMessage(
      {required String email,
      required String phone,
      required String content}) async {
    try {
      final response = await Dio().post(
        ApiConstant.contactUs,
        options: Options(
          headers: ApiConstant.headers,
          validateStatus: (status) => status! < 500,
        ),
        data: {
          'email': email,
          'phone': phone,
          'content': content,
        },
      );

      log(response.data.toString());

      if (response.statusCode == 200) {
        return ContactModel.fromJson(response.data);
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
