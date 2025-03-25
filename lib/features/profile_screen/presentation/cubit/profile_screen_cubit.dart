import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/features/profile_screen/data/datasources/profile_dataSource.dart';
import 'package:ahfaz_damanak/features/profile_screen/data/models/profile_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/profil_repository.dart';

part 'profile_screen_state.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  ProfileScreenCubit() : super(ProfileScreenInitial());
  Profile? profile;
  void getProfile() {
    emit(ProfileScreenLoading());
    ProfileDatasource profileDatasource = ProfileDataSourceImpl();
    ProfilRepository profilRepository = ProfilRepository(profileDatasource);
    profilRepository
        .getUser()
        .then((value) => value.fold((l) => emit(ProfileScreenError()), (r) {
              profile = r;
              emit(ProfileScreenLoaded(r));
            }));
  }

  void editProfile({
    required String phoneNumber,
    required String userId,
    required String name,
  }) {
    emit(ProfileScreenLoading());
    ProfileDatasource profileDatasource = ProfileDataSourceImpl();
    ProfilRepository profilRepository = ProfilRepository(profileDatasource);
    profilRepository
        .editProfile(
          phoneNumber: profile!.phone,
          userId: token!,
          name: profile!.name,
        )
        .then((value) => value.fold((l) => emit(ProfileScreenError()), (r) {
              profile = r;
              emit(ProfileScreenLoaded(r));
            }));
  }
}
