import 'dart:developer';

import 'package:ahfaz_damanak/features/notification/data/models/notification_model.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/server_excption.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/error_model.dart';
import '../../../../core/utils/constant.dart';

abstract class NotificationDatasource {
  Future<List<NotificationModel>> getNotification();
}

class NotificationDatasourceImpl implements NotificationDatasource {
  final Dio dio;
  NotificationDatasourceImpl(this.dio);
  @override
  Future<List<NotificationModel>> getNotification() async {
    try {
      final response = await dio.get(
        ApiConstant.notifications,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${Constants.token}',
          },
        ),
      );

      if (response.statusCode == 200) {
        log(response.data.toString());
        final data = response.data['data'];
        return (data as List)
            .map((item) => NotificationModel.fromJson(item))
            .toList();
      } else {
        throw ServerException(errorModel: ErrorModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
    }
  }
}
