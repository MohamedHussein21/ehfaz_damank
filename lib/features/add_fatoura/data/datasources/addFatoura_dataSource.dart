import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

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
    File imageFile = File(image.path);

    FormData formData = FormData.fromMap({
      'category_id': categoryId,
      'name': name,
      'store_name': storeName,
      'purchase_date': purchaseDate,
      'fatora_number': fatoraNumber,
      'daman': daman,
      'daman_date': damanDate,
      'notes': notes,
      'price': price,
      'reminder': reminder,
      'image': await MultipartFile.fromFile(imageFile.path, filename: 'hh.png'),
    });

    final response = await Dio().post(
      ApiConstant.addFatora,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token',
        },
        //  validateStatus: (status) => status! < 500,
      ),
      data: formData,
    );

    log('Response Data: ${response.data}');

    return FatoraModel.fromJson(response.data['data']);
    try {} on DioException catch (e) {
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
  Future<FatoraModel> deleteFatoura({required int id}) async {
    try {
      final response = await Dio().post(
        ApiConstant.delFatora,
        options: Options(
          headers: ApiConstant.headers,
          validateStatus: (status) => status! < 500,
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
