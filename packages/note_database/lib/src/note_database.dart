import 'package:note_database/src/models/note_structure/note_structure.dart';
abstract class NoteDatabase {
  /// {@macro database}
  NoteDatabase();

  // Future<Note> getNote(String uid);

  // Future<void> putNote(Note note);

  // Future<void> deleteNote(String uid);

  Future<dynamic> getDynamic(String uid);

  // Future<dynamic> putDynamic(dynamic item);

  Future<dynamic> putDynamicWithUid(String uid,dynamic item);

  Future<void> deleteDynamic(String uid);


}
