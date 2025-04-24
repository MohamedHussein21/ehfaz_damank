import 'package:ahfaz_damanak/core/errors/Failure.dart';
import 'package:ahfaz_damanak/features/notification/data/datasources/notification_dataSource.dart';
import 'package:ahfaz_damanak/features/notification/data/models/notification_model.dart';
import 'package:ahfaz_damanak/features/notification/domain/repositories/notification_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/server_excption.dart';

class NotificationRepository extends NotificationRepo {
  final NotificationDatasource notificationDataSource;
  NotificationRepository(this.notificationDataSource);
  @override
  Future<Either<Failure, List<NotificationModel>>> getNotification() async {
    try {
      final result = await notificationDataSource.getNotification();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(FailureServer(failure.errorModel.data,
          msg: failure.errorModel.detail));
    }
  }
}
