import 'package:ahfaz_damanak/core/errors/Failure.dart';
import 'package:ahfaz_damanak/features/notes/data/models/NotesModel.dart';
import 'package:dartz/dartz.dart';

abstract class NotesRepo {
  Future<Either<Failure, List<NotesModel>>> getNotes();
}
