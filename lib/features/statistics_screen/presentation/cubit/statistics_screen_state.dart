part of 'statistics_screen_cubit.dart';

abstract class StatisticsScreenState extends Equatable {
  const StatisticsScreenState();

  @override
  List<Object> get props => [];
}

class StatisticsScreenInitial extends StatisticsScreenState {}

class StatisticsScreenLoading extends StatisticsScreenState {}

class StatisticsScreenSuccess extends StatisticsScreenState {
  final StatisticsModel statistics;
  const StatisticsScreenSuccess(this.statistics);
}

class StatisticsScreenError extends StatisticsScreenState {}
