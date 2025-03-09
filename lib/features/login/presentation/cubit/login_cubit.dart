import 'package:ahfaz_damanak/features/login/data/models/user_model.dart';
import 'package:ahfaz_damanak/features/login/data/repositories/login_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/login_datasource.dart';
import '../../domain/repositories/login_repositery.dart';
import '../../domain/usecases/login_use_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;
  void userLogin({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    BaseRemoteDataSource baseRemoteDataSource = RemoteDataSource();
    BaseLoginRepository baseAuthRepository = LoginRepo(baseRemoteDataSource);
    final result = await LoginUseCase(baseAuthRepository)
        .execute(email: email, password: password);
    result.fold((l) => emit(LoginError(l.massage)), (r) {
      emit(LoginLoaded(r, r.token ?? ''));
      userModel = r;
    });
  }
}
