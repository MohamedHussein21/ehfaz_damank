import 'package:ahfaz_damanak/features/home_screen/data/datasources/home_data_source.dart';
import 'package:ahfaz_damanak/features/home_screen/domain/repositories/home_repo.dart';
import 'package:ahfaz_damanak/features/home_screen/domain/usecases/home_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

import '../../data/models/home_model.dart';
import '../../data/repositories/home_repositories.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(HomeScreenInitial());

  OrdersResponse? ordersResponse;

  void getData() async {
    emit(HomeScreenLoading());
    HomeDataSource homeDataSource = HomeDataSourceImpl(Dio());
    HomeRepo homeRepo = HomeRepositories(homeDataSource);
    final result = await HomeUseCase(homeRepo).execute();
    result.fold(
      (l) => emit(HomeScreenError(l.msg)),
      (r) {
        ordersResponse = r;
        emit(HomeScreenSuccess(r));
      },
    );
  }
}
