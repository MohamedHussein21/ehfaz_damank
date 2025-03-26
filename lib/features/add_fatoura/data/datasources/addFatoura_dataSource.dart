import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/server_excption.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/error_model.dart';
import 'package:ahfaz_damanak/features/add_fatoura/data/models/add_fatoura_model.dart';

import '../../../../core/utils/constant.dart';

abstract class AddfatouraDatasource {
  Future<FatoraModel> addFatora({
    required int categoryId,
    required String name,
    required String storeName,
    required String purchaseDate,
    required String fatoraNumber,
    required int daman,
    required String damanDate,
    required String notes,
    required int price,
    required int reminder,
    required XFile image,
  });

  Future<FatoraModel> deleteFatoura({
    required int id,
  });
}

class AddFatouraRemoteDataSource extends AddfatouraDatasource {
  @override
  Future<FatoraModel> addFatora({
    required int categoryId,
    required String name,
    required String storeName,
    required String purchaseDate,
    required String fatoraNumber,
    required int daman,
    required String damanDate,
    required String notes,
    required int price,
    required int reminder,
    required XFile image,
  }) async {
    FormData formData = FormData.fromMap({
      "category_id": categoryId.toString(),
      "name": name,
      "store_name": storeName,
      "purchase_date": purchaseDate,
      "fatora_number": fatoraNumber,
      "daman": daman.toString(),
      "daman_date": damanDate,
      "notes": notes,
      "price": price.toString(),
      "reminder": reminder.toString(),
      if (image != null)
        "image": await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
          contentType: MediaType("image", "jpeg"),
        ),
    });

    final response = await Dio().post(
      ApiConstant.addFatora,
      data: formData,
      options: Options(
        headers: {
          "Content-Type": "multipart/form-data",
          "Authorization": "Bearer $token",
        },
      ),
    );

    log('Response Data: ${response.data}');
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      return FatoraModel.fromJson(response.data['data']);
    } else {
      Constants.showToast(
          text: response.data['message'], state: ToastStates.error);
      throw ServerException(errorModel: ErrorModel.fromJson(response.data));
    }
  }

  @override
  Future<FatoraModel> deleteFatoura({required int id}) async {
    try {
      final response = await Dio().post(
        ApiConstant.delFatora,
        options: Options(
          headers: ApiConstant.headers,
        ),
        data: {
          'id': id,
        },
      );

      log('Response: ${response.data}');
      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        return FatoraModel.fromJson(response.data);
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
