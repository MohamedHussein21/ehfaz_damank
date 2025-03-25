import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../data/models/statistics_model.dart';

abstract class StatisticsRepo {
  Future<Either<Failure, StatisticsModel>> getStatistics();
}
