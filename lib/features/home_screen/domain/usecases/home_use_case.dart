import 'package:ahfaz_damanak/features/home_screen/data/models/home_model.dart';
import 'package:ahfaz_damanak/features/home_screen/domain/repositories/home_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';

class HomeUseCase {
  final HomeRepo homeRepo;

  HomeUseCase(this.homeRepo);

  Future<Either<Failure, OrdersResponse>> execute() async {
    return await homeRepo.getHomeData();
  }
}
