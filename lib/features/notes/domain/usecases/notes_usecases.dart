import 'package:ahfaz_damanak/core/errors/Failure.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/NotesModel.dart';
import '../repositories/notes_repo.dart';

class NotesUsecases {
  final NotesRepo notesRepo;
  NotesUsecases(this.notesRepo);

  Future<Either<Failure, List<NotesModel>>> getNotes() async {
    return await notesRepo.getNotes();
  }
}
