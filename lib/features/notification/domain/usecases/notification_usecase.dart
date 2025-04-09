import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../data/models/notification_model.dart';
import '../repositories/notification_repo.dart';

class NotificationUsecase {
  final NotificationRepo _notificationRepo;
  NotificationUsecase(this._notificationRepo);

  Future<Either<Failure, List<NotificationModel>>> getNotification() =>
      _notificationRepo.getNotification();
}
