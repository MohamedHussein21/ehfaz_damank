part of 'add_fatoura_cubit.dart';

abstract class AddFatouraState extends Equatable {
  const AddFatouraState();

  @override
  List<Object> get props => [];
}

class AddFatouraInitial extends AddFatouraState {}

class AddFatouraLoading extends AddFatouraState {}

class AddFatouraError extends AddFatouraState {
  final String message;
  const AddFatouraError(this.message);
}

class AddFatouraSuccess extends AddFatouraState {
  final FatoraModel addFatoraModel;
  const AddFatouraSuccess(this.addFatoraModel);
}
