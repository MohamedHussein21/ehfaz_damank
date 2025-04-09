import 'package:ahfaz_damanak/features/profile_screen/data/datasources/profile_dataSource.dart';
import 'package:ahfaz_damanak/features/profile_screen/data/models/profile_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/profil_repository.dart';

part 'profile_screen_state.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  ProfileScreenCubit() : super(ProfileScreenInitial());
  Profile? profile;
  EditProfileModel? editProfileModel;
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
    required String phone,
    required String name,
  }) {
    emit(EditProfileLoading());
    ProfileDatasource profileDatasource = ProfileDataSourceImpl();
    ProfilRepository profilRepository = ProfilRepository(profileDatasource);
    profilRepository
        .editProfile(
          phone: phone,
          name: name,
        )
        .then((value) => value.fold((l) => emit(EditProfileError()), (r) {
              editProfileModel = r;
              emit(EditProfileLoaded(r));
            }));
  }

  void deleteUser({required String userId}) {
    emit(DeleteUserLoading());
    ProfileDatasource profileDatasource = ProfileDataSourceImpl();
    ProfilRepository profilRepository = ProfilRepository(profileDatasource);
    profilRepository
        .deleteUser(userId: userId)
        .then((value) => value.fold((l) => emit(DeleteUserError()), (r) {}));
  }

  void clear() {
    profile = null;
    editProfileModel = null;
    emit(ProfileScreenInitial());
  }
}
