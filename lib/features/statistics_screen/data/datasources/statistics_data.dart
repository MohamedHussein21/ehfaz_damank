import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/errors/server_excption.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/error_model.dart';
import '../../../../core/utils/constant.dart';
import '../models/statistics_model.dart';

abstract class StatisticsDataSource {
  Future<StatisticsModel> getStatistics();
}

ErrorModel _handleError(Response response) {
  return ErrorModel(detail: 'Error: ${response.statusCode}');
}

ErrorModel _handleDioError(DioException e) {
  return ErrorModel(detail: 'Dio Error: ${e.message}');
}

class StatisticsDataSourceImp implements StatisticsDataSource {
  final Dio dio;
  StatisticsDataSourceImp(this.dio);
  @override
  Future<StatisticsModel> getStatistics() async {
    try {
      final response = await dio.get(
        ApiConstant.statistics,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${Constants.token}',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      log('Response Status: ${response.statusCode}');
      log('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        return StatisticsModel.fromJson(response.data);
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
}
