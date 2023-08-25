import 'dart:io' as IO;

import 'package:note_database/note_database.dart';
import 'package:permission_handler/permission_handler.dart';

class NoteRepository{
  ///singleton
  factory NoteRepository() => _instance;
  static late final NoteRepository _instance = NoteRepository._internal();
  NoteRepository._internal();

  Future<void> init() async{

    String path;
    if(IO.Platform.isWindows){
      path=r"E:\tmp\notes";
    }
    else if(IO.Platform.isAndroid){
      path=r'storage/emulated/0/documents/felling_good';
    }
    else{
      throw 'platform not support';
    }
    var status = await Permission.storage.request();
    if(status==PermissionStatus.denied){
      throw 'permission denied';
    }
    var folder = IO.Directory(path);
    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
    }
    noteDatabase=HiveNoteDataBase(path);
  }
  late NoteDatabase noteDatabase;
  Future<void> saveNote(Note note) async {
    await noteDatabase.putNote(note);
  }
  Future<Note> getNote(String uid) async{
    return noteDatabase.getNote(uid);
  }

  Future<void> deleteNote(String uid) async{
    return noteDatabase.deleteNote(uid);
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