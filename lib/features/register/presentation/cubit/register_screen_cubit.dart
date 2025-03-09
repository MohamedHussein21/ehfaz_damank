import 'package:ahfaz_damanak/features/register/data/repositories/register_repo.dart';
import 'package:ahfaz_damanak/features/register/domain/usecases/register_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../login/data/datasources/login_datasource.dart';
import '../../../login/data/models/user_model.dart';
import '../../../login/data/repositories/login_repo.dart';
import '../../data/datasources/register_data_source.dart';
import '../../domain/repositories/register_repository.dart';

part 'register_screen_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterScreenInitial());

  static RegisterCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;
  void userRegister({
    required String password,
    required String name,
    required String phone,
  }) async {
    emit(RegisterScreenLoading());
    BaseRegisterRemoteDataSource baseRemoteDataSource =
        RegisterRemoteDataSource();
    BaseRegisterRepository baseAuthRepository =
        RegisterRepo(baseRemoteDataSource);
    final result = await RegisterUsecase(baseAuthRepository)
        .execute(name: name, phone: phone, password: password);
    result.fold((l) => emit(RegisterScreenError(l.massage)), (r) {
      emit(RegisterScreenLoaded(r, r.token ?? ''));
      userModel = r;
    });
  }
}
