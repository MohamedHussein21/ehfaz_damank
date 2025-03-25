import 'package:ahfaz_damanak/core/errors/Failure.dart';
import 'package:ahfaz_damanak/features/statistics_screen/data/models/statistics_model.dart';
import 'package:ahfaz_damanak/features/statistics_screen/domain/repositories/statistics_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/server_excption.dart';
import '../datasources/statistics_data.dart';

class StatisticsRepository extends StatisticsRepo {
  StatisticsDataSource statisticsDataSource;

  StatisticsRepository({required this.statisticsDataSource});
  @override
  Future<Either<Failure, StatisticsModel>> getStatistics() async {
    final result = await statisticsDataSource.getStatistics();

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(FailureServer(msg: failure.errorModel.detail));
    }
  }
}
