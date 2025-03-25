import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../data/models/statistics_model.dart';
import '../repositories/statistics_repo.dart';

class StatisticsUsecase {
  final StatisticsRepo statisticsRepo;

  StatisticsUsecase(this.statisticsRepo);
  Future<Either<Failure, StatisticsModel>> getStatistics() async =>
      await statisticsRepo.getStatistics();
}
