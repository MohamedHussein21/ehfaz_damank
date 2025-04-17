import 'dart:developer';
import 'package:ahfaz_damanak/core/helper/cash_helper.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/server_excption.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/error_model.dart';
import '../models/home_model.dart';

abstract class HomeDataSource {
  Future<OrdersResponse> getHomeData();
}

class HomeDataSourceImpl extends HomeDataSource {
  final Dio dio;

  HomeDataSourceImpl(this.dio);

  @override
  Future<OrdersResponse> getHomeData() async {
    try {
      final response = await dio.get(
        ApiConstant.home,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            if (Constants.token != null)
              'Authorization': 'Bearer ${Constants.token}',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      log('Response Status: ${response.statusCode}');
      log('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        return OrdersResponse.fromJson(response.data);
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
