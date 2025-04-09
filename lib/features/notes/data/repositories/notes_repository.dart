import 'package:ahfaz_damanak/core/errors/Failure.dart';
import 'package:ahfaz_damanak/features/notes/data/models/NotesModel.dart';
import 'package:ahfaz_damanak/features/notes/domain/repositories/notes_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/server_excption.dart';
import '../datasources/notes_data_sourcw.dart';

class NotesRepository extends NotesRepo {
  final NotesDataSource notesDataSource;
  NotesRepository(this.notesDataSource);
  @override
  Future<Either<Failure, List<NotesModel>>> getNotes() async {
    try {
      final result = await notesDataSource.getNotes();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(FailureServer(msg: failure.errorModel.detail));
    }
  }
}
