part of 'contactus_cubit.dart';

abstract class ContactusState extends Equatable {
  const ContactusState();

  @override
  List<Object> get props => [];
}

class ContactusInitial extends ContactusState {}

class ContactusLoading extends ContactusState {}

class ContactusSuccess extends ContactusState {
  final ContactModel message;

  const ContactusSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ContactusError extends ContactusState {}
