import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'statistics_screen_state.dart';

class StatisticsScreenCubit extends Cubit<StatisticsScreenState> {
  StatisticsScreenCubit() : super(StatisticsScreenInitial());
}
