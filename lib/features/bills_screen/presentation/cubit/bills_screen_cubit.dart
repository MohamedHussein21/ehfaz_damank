import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bills_screen_state.dart';

class BillsScreenCubit extends Cubit<BillsScreenState> {
  BillsScreenCubit() : super(BillsScreenInitial());
}
