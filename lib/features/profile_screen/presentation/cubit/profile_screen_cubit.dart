import 'dart:developer';

import 'package:ahfaz_damanak/core/helper/cash_helper.dart';
import 'package:ahfaz_damanak/features/profile_screen/data/datasources/profile_dataSource.dart';
import 'package:ahfaz_damanak/features/profile_screen/data/models/profile_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../login/presentation/cubit/login_cubit.dart';
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

  /// Logs out the current user by clearing stored data
  /// Uses LoginCubit's logout function if available, otherwise falls back to CashHelper
  Future<void> logout(context) async {
    emit(LogoutLoading());

    try {
      // Try to use LoginCubit if available
      if (context != null) {
        try {
          final loginCubit =
              BlocProvider.of<LoginCubit>(context, listen: false);

          // Check if the logout was successful
          if (loginCubit.state is LoggedOut) {
            final loggedOutState = loginCubit.state as LoggedOut;
            if (loggedOutState.success) {
              // Clear profiel data and emit success
              clear();
              emit(LogoutSuccess());
              return;
            } else {
              // Emit error with message from LoginCubit
              emit(LogoutError(loggedOutState.message ?? "Logout failed"));
              return;
            }
          }
        } catch (e) {
          log("Failed to use LoginCubit for logout: $e");
          // Continue with fallback if LoginCubit is not available
        }
      }

      // Fallback: use CashHelper directly
      final success = await CashHelper.logout();

      if (success) {
        // Clear profile data and emit success
        clear();
        emit(LogoutSuccess());
      } else {
        emit(const LogoutError("Failed to clear user data"));
      }
    } catch (e) {
      log("Logout Error: $e");
      emit(LogoutError("Error during logout: $e"));
    }
  }
}
