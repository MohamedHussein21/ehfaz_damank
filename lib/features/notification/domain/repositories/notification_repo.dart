import 'package:ahfaz_damanak/features/notification/data/models/notification_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';

abstract class NotificationRepo {
  Future<Either<Failure, List<NotificationModel>>> getNotification();
}
