part of 'profile_screen_cubit.dart';

abstract class ProfileScreenState extends Equatable {
  const ProfileScreenState();

  @override
  List<Object> get props => [];
}

class ProfileScreenInitial extends ProfileScreenState {}

class ProfileScreenLoading extends ProfileScreenState {}

class ProfileScreenLoaded extends ProfileScreenState {
  final Profile profile;
  const ProfileScreenLoaded(this.profile);
}

class ProfileScreenError extends ProfileScreenState {}

class EditProfileLoading extends ProfileScreenState {}

class EditProfileLoaded extends ProfileScreenState {
  final EditProfileModel editProfileModel;
  const EditProfileLoaded(this.editProfileModel);
}
class EditProfileError extends ProfileScreenState {}

class DeleteUserLoading extends ProfileScreenState {}

class DeleteUserLoaded extends ProfileScreenState {
  final EditProfileModel editProfileModel;
  const DeleteUserLoaded(this.editProfileModel);

}

class DeleteUserError extends ProfileScreenState {}

class LogoutLoading extends ProfileScreenState {}

class LogoutSuccess extends ProfileScreenState {}

class LogoutError extends ProfileScreenState {
  final String message;

  const LogoutError(this.message);

  @override
  List<Object> get props => [message];
}
