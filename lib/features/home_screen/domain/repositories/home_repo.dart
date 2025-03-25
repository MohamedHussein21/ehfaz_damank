import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../data/models/home_model.dart';

abstract class HomeRepo {
  Future<Either<Failure, OrdersResponse>> getHomeData();
}
