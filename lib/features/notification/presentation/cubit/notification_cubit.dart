import 'package:ahfaz_damanak/features/notification/data/datasources/notification_dataSource.dart';
import 'package:ahfaz_damanak/features/notification/data/repositories/notification_repository.dart';
import 'package:ahfaz_damanak/features/notification/domain/repositories/notification_repo.dart';
import 'package:ahfaz_damanak/features/notification/domain/usecases/notification_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/notification_model.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  List<NotificationModel>? notificationModel;

  void getNotification() async {
    emit(NotificationLoading());
    NotificationDatasource notificationDatasource =
        NotificationDatasourceImpl(Dio());
    NotificationRepo notificationRepo =
        NotificationRepository(notificationDatasource);
    final result =
        await NotificationUsecase(notificationRepo).getNotification();
    result.fold((l) => emit(NotificationError(l.msg)), (r) {
      emit(NotificationLoaded(r));
      notificationModel = r;
    });
  }
}
