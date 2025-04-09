part of 'notification_cubit.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notificationModel;

  const NotificationLoaded(this.notificationModel);

  @override
  List<Object> get props => [notificationModel];
}

class NotificationError extends NotificationState {
  final String error;

  const NotificationError(this.error);

  @override
  List<Object> get props => [error];
}
