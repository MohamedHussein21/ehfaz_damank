import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/errors/server_excption.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/error_model.dart';
import '../../../../core/utils/constant.dart';
import '../models/NotesModel.dart';

abstract class NotesDataSource {
  Future<List<NotesModel>> getNotes();
}

class NotesDataSourceImpl implements NotesDataSource {
  final Dio dio;

  NotesDataSourceImpl({required this.dio});

  @override
  Future<List<NotesModel>> getNotes() async {
    try {
      final response = await dio.get(
        ApiConstant.notes,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      log('Response Status: ${response.statusCode}');
      log('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((note) => NotesModel.fromJson(note))
            .toList();
      } else {
        throw ServerException(errorModel: _handleError(response));
      }
    } on DioException catch (e) {
      log('DioException: ${e.message}');
      throw ServerException(errorModel: _handleDioError(e));
    } catch (e) {
      log('Unexpected Error: $e');
      throw ServerException(
          errorModel: ErrorModel(detail: 'حدث خطأ غير متوقع'));
    }
  }

  ErrorModel _handleError(Response response) {
    try {
      return ErrorModel.fromJson(response.data);
    } catch (_) {
      return ErrorModel(detail: 'خطأ في تحليل الاستجابة');
    }
  }

  ErrorModel _handleDioError(DioException e) {
    if (e.response != null) {
      return _handleError(e.response!);
    } else {
      return ErrorModel(detail: 'تعذر الاتصال بالخادم');
    }
  }
}
