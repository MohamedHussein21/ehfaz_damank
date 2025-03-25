import 'package:ahfaz_damanak/features/home_screen/data/datasources/home_data_source.dart';
import 'package:ahfaz_damanak/features/home_screen/data/models/home_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../../../../core/errors/server_excption.dart';
import '../../domain/repositories/home_repo.dart';

class HomeRepositories extends HomeRepo {
  final HomeDataSource homeDataSource;

  HomeRepositories(this.homeDataSource);

  @override
  Future<Either<Failure, OrdersResponse>> getHomeData() async {
    final result = await homeDataSource.getHomeData();

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(FailureServer(msg: failure.errorModel.detail));
    }
  }
}
