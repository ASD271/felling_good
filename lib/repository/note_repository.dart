import 'package:note_database/note_database.dart';

class NoteRepository{
  ///singleton
  factory NoteRepository() => _instance;
  static late final NoteRepository _instance = NoteRepository._internal();
  NoteRepository._internal(){}
  NoteDatabase noteDatabase=HiveNoteDataBase(r"E:\tmp\notes");
  Future<void> saveNote(Note note) async {
    await noteDatabase.putNote(note);
  }
  Future<Note> getNote(String uid) async{
    return noteDatabase.getNote(uid);
  }

  Future<Directory> getDirectory(String uid) async{
    if(!uid.startsWith('directory')){
      throw "$uid error when get directory";
    }
    Directory? dy=await noteDatabase.getDynamic(uid);
    if(dy==null) {
     throw 'dir uid not exist';
    };
    return  dy as Directory;
  }

  Future<void> saveDir(Directory directory) async{
    if(!directory.uid.startsWith('directory')){
      throw "${directory.uid} error when put directory";
    }
    await noteDatabase.putDynamic(directory);
  }
}