import 'package:ahfaz_damanak/features/statistics_screen/data/repositories/statistics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../data/datasources/statistics_data.dart';
import '../../data/models/statistics_model.dart';
import '../../domain/repositories/statistics_repo.dart';
import '../../domain/usecases/statistics_useCase.dart';

part 'statistics_screen_state.dart';

class StatisticsScreenCubit extends Cubit<StatisticsScreenState> {
  StatisticsScreenCubit() : super(StatisticsScreenInitial());

  StatisticsModel? statisticsModel;

  Future<void> getStatistics() async {
    emit(StatisticsScreenLoading());
    StatisticsDataSource statisticsDataSource = StatisticsDataSourceImp(Dio());
    StatisticsRepo statisticsRepo =
        StatisticsRepository(statisticsDataSource: statisticsDataSource);
    final result = await StatisticsUsecase(statisticsRepo).getStatistics();
    result.fold(
      (l) => emit(StatisticsScreenError()),
      (r) {
        statisticsModel = r;
        emit(StatisticsScreenSuccess(r));
      },
    );
  }
}
