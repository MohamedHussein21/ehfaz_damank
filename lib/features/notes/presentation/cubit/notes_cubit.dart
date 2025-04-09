import 'package:ahfaz_damanak/features/notes/data/datasources/notes_data_sourcw.dart';
import 'package:ahfaz_damanak/features/notes/data/repositories/notes_repository.dart';
import 'package:ahfaz_damanak/features/notes/domain/repositories/notes_repo.dart';
import 'package:ahfaz_damanak/features/notes/domain/usecases/notes_usecases.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/NotesModel.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial());

  List<NotesModel>? notesModel;
  void getData() async {
    emit(NotesLoading());
    NotesDataSource homeDataSource = NotesDataSourceImpl(dio: Dio());
    NotesRepo homeRepo = NotesRepository(homeDataSource);
    final result = await NotesUsecases(homeRepo).getNotes();
    result.fold(
      (l) => emit(NotesError(message: l.msg)),
      (r) {
        notesModel = r;
        emit(NotesLoaded(notes: r));
      },
    );
  }
}
