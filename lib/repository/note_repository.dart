import 'dart:convert';
import 'dart:io' as IO;

import 'package:felling_good/utils/extension.dart';
import 'package:note_database/note_database.dart';
import 'package:permission_handler/permission_handler.dart';

class NoteRepository {
  ///singleton
  factory NoteRepository() => _instance;
  static late final NoteRepository _instance = NoteRepository._internal();

  NoteRepository._internal();

  Future<void> init() async {
    String path;
    if (IO.Platform.isWindows) {
      path = r"E:\tmp\notes";
    } else if (IO.Platform.isAndroid) {
      path = r'storage/emulated/0/documents/felling_good';
    } else {
      throw 'platform not support';
    }
    var status = await Permission.storage.request();
    if (status == PermissionStatus.denied) {
      throw 'permission denied';
    }
    var folder = IO.Directory(path);
    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
    }
    noteDatabase = HiveNoteDataBase(path);
  }

  late NoteDatabase noteDatabase;

  Future<void> saveNote(Note note) async {
    await noteDatabase.putDynamicWithUid(note.uid,note.toJsonString());
  }

  Future<Note> getNote(String uid) async {
    return Note.fromJsonString(await noteDatabase.getDynamic(uid) as String);
  }

  Future<void> deleteNote(String uid) async {
    assert(uid.startsWith('note'), 'uid error when note repository delete note');
    return noteDatabase.deleteDynamic(uid);
  }

  Future<void> deleteDirectory(String uid) async {
    assert(uid.startsWith('directory'), 'uid error when note repository delete directory');
    return noteDatabase.deleteDynamic(uid);
  }

  Future<Directory> getDirectory(String uid) async {
    if (!uid.startsWith('directory')) {
      throw "$uid error when get directory";
    }
    String json=await noteDatabase.getDynamic(uid) as String;
    Directory dy = Directory.fromJsonString(json);
    return dy;
  }

  Future<void> saveDir(Directory directory) async {
    if (!directory.uid.startsWith('directory')) {
      throw "${directory.uid} error when put directory";
    }
    await noteDatabase.putDynamicWithUid(directory.uid,directory.toJsonString());
  }

  Future<void> savePreferenceInfo(PreferenceInfo preferenceInfo) async {
    await noteDatabase.putDynamicWithUid(preferenceInfo.uid,json.encode(preferenceInfo.toJson()));
  }

  Future<PreferenceInfo> getPreferenceInfo() async {
    String? jsonString = (await noteDatabase.getDynamic('info-preference'));
    return PreferenceInfo.fromJson(jsonString != null ? jsonDecode(jsonString) : {});
  }
}

class PreferenceInfo {
  final String uid = 'info-preference';

  late List<String> lastOpenedNote;
  late String sortRule;

  PreferenceInfo();

  factory PreferenceInfo.fromJson(Map<String, dynamic> jsonMap) {
    return PreferenceInfo()
      ..lastOpenedNote = jsonMap.getValue('lastOpenedNote',[]).cast<String>()
      ..sortRule = jsonMap.getValue('sortRule', 'default');
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'lastOpenedNote': lastOpenedNote,
      'sortRule': sortRule
    };
  }

  PreferenceInfo copyWith({List<String>? lastOpenedNote, String? sortRule}) {
    return PreferenceInfo()
      ..lastOpenedNote = lastOpenedNote ?? this.lastOpenedNote
      ..sortRule = sortRule ?? this.sortRule;
  }
}
