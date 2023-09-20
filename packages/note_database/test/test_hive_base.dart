// import 'dart:io';
//
// import 'package:hive/hive.dart';
// import 'package:note_database/note_database.dart';
//
// String boxName='test';
// Future<Note> getNote(String uid) async {
//   final noteBox=await Hive.openBox<dynamic>(boxName);
//   return (noteBox.get(uid)) as Note;
// }
// Future<void> saveNote(Note note) async {
//   final noteBox=await Hive.openBox<dynamic>(boxName);
//   await noteBox.put(note.uid, note);
// }
//
// void main() async{
//   // var x=Note("nice to meet you again",title: 'first note');
//   // var path = r"E:\project\flutter\felling_good\packages\note_database\test\hives";
//
//   // Hive
//   //   ..init(path)
//   //   ..registerAdapter(NoteAdapter());
//
//
//   // var noteBox=await Hive.openBox("test");
//   // await noteBox.put("key", x);
//   //
//   // var noteBox2=await Hive.openBox("test");
//   // var y=noteBox2.get("key") as Note;
//   // print(y);
//
//
//
//   NoteDatabase d=HiveNoteDataBase(path);
//   // final noteBox=await Hive.openBox<dynamic>('test');
//   // await noteBox.put(x.uid, x);
//   // await saveNote(x);
//   // Note y=await getNote(x.uid);
//   // print(y.jsonContent);
//   d.putNote(x);
//   Note y=await d.getNote(x.uid);
//   print(y.jsonContent);
//   print(y.itemAttribute.createTime);
// }