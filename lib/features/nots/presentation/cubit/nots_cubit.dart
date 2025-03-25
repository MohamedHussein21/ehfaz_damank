import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'nots_state.dart';

class NotsCubit extends Cubit<NotsState> {
  NotsCubit() : super(NotsInitial());
}
