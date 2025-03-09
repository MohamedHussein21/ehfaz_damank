import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notifaction_screen_state.dart';

class NotifactionScreenCubit extends Cubit<NotifactionScreenState> {
  NotifactionScreenCubit() : super(NotifactionScreenInitial());
}
