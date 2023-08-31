import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:note_database/note_database.dart';


///save note based on flutter_hive
class HiveNoteDataBase extends NoteDatabase {
  ///construct a hive box based on the path and name
  ///and register adapter
  HiveNoteDataBase(String path, {this.boxName = 'hiveNoteBox'}) {
    Hive
      ..init(path);
      // ..registerAdapter(NoteAdapter())
      // ..registerAdapter(TagsAdapter())
      // ..registerAdapter(ItemAttributeAdapter())
      // ..registerAdapter(DirectoryAdapter());
    // TODO(hiveBase): adapter was added one by one by hands, may not elegant
  }

  ///name of hive box
  String boxName;

  ///a box which store all notes data

  // @override
  // Future<Note> getNote(String uid) async {
  //   final noteBox = await Hive.openBox<dynamic>(boxName);
  //   // return (noteBox.get(uid)) as Note;
  //   return Note.fromJson(string2map(noteBox.get(uid) as String));
  // }
  //
  // @override
  // Future<void> deleteNote(String uid) async{
  //   final noteBox=await Hive.openBox<dynamic>(boxName);
  //   await noteBox.delete(uid);
  // }

  // @override
  // Future<void> putNote(Note note) async {
  //   final noteBox = await Hive.openBox<dynamic>(boxName);
  //   await noteBox.put(note.uid, note);
  // }

  Future<dynamic> getDynamic(String uid) async{
    final noteBox = await Hive.openBox<dynamic>(boxName);
    return noteBox.get(uid);
  }


  @override
  Future<void> deleteDynamic(String uid) async{
    final noteBox=await Hive.openBox<dynamic>(boxName);
    await noteBox.delete(uid);
  }

  @override
  Future<dynamic> putDynamicWithUid(String uid,dynamic item)async {
    final noteBox = await Hive.openBox<dynamic>(boxName);
    await noteBox.put(uid, item);
  }
}
