import 'package:equatable/equatable.dart';

import '../../data/models/bills_model.dart';
import '../../data/models/del_model.dart';
import '../../data/models/edit_fatora.dart';

abstract class BillsScreenState extends Equatable {
  const BillsScreenState();

  @override
  List<Object> get props => [];
}

class BillsScreenInitial extends BillsScreenState {}

class BillsScreenLoading extends BillsScreenState {}

class BillsScreenSuccess extends BillsScreenState {
  final List<Bill> billsModel;

  const BillsScreenSuccess(this.billsModel);

  @override
  List<Object> get props => [billsModel];
}

class BillsScreenError extends BillsScreenState {
  final String message;

  const BillsScreenError(this.message);

  @override
  List<Object> get props => [message];
}

class BillDeletingLouding extends BillsScreenState {}

class BillDeletingSuccus extends BillsScreenState {
  final DeleteModel deleteModel;

  const BillDeletingSuccus({required this.deleteModel});
}

class BillDeletingError extends BillsScreenState {
  final String message;

  const BillDeletingError(this.message);
}

class EditFatouraLouding extends BillsScreenState {}

class EditFatouraSuccus extends BillsScreenState {
  final EditFatouraResponseModel editFatouraResponseModel;

  const EditFatouraSuccus({required this.editFatouraResponseModel});
}

class EditFatouraError extends BillsScreenState {
  final String message;

  const EditFatouraError(this.message);
}
