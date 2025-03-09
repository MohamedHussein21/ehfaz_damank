import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profilescreen_event.dart';
part 'profilescreen_state.dart';

class ProfilescreenBloc extends Bloc<ProfilescreenEvent, ProfilescreenState> {
  ProfilescreenBloc() : super(ProfilescreenInitial()) {
    on<ProfilescreenEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
