import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_screen_state.dart';

class AddScreenCubit extends Cubit<AddScreenState> {
  AddScreenCubit() : super(AddScreenInitial());
}
