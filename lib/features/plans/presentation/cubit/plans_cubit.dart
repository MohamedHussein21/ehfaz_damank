import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'plans_state.dart';

class PlansCubit extends Cubit<PlansState> {
  PlansCubit() : super(PlansInitial());
}
