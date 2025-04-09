import 'package:ahfaz_damanak/features/contactUs/data/datasources/contact_dataSource.dart';
import 'package:ahfaz_damanak/features/contactUs/data/models/contact_model.dart';
import 'package:ahfaz_damanak/features/contactUs/data/repositories/contact_repository.dart';
import 'package:ahfaz_damanak/features/contactUs/domain/repositories/contact_repo.dart';
import 'package:ahfaz_damanak/features/contactUs/domain/usecases/contact_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'contactus_state.dart';

class ContactusCubit extends Cubit<ContactusState> {
  ContactusCubit() : super(ContactusInitial());

  static ContactusCubit get(context) => BlocProvider.of(context);

  ContactModel? contactModel;

  void sentMassege({
    required String email,
    required String phone,
    required String content,
  }) async {
    emit(ContactusLoading());
    ContactRemoteDataSource contactRemoteDataSource = ContactRemoteDataSource();
    ContactRepo contactRepo =
        ContactRepository(contactRemoteDataSource: contactRemoteDataSource);
    final result = await ContactUsecase(contactRepo)
        .sendMessage(email: email, phone: phone, content: content);
    result.fold((l) => emit(ContactusError()), (r) {
      emit(ContactusSuccess(r));
      contactModel = r;
    });
  }
}
