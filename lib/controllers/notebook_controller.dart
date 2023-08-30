import 'dart:async';

import 'package:felling_good/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:note_database/note_database.dart';

import '../repository/note_repository.dart';
import 'note_select/note_select_page_controller.dart';

class NotebookController extends GetxController {
  RxBool inited = false.obs;
  NoteRepository noteRepository = NoteRepository();

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();
  Map<String, dynamic> notebookItems = {};
  late PreferenceInfo preferenceInfo;
  Completer<void> noteBookCompleter = Completer();

  // Map<String, NoteItem> items = {};

  @override
  void onInit() async {
    super.onInit();
    preferenceInfo = await noteRepository.getPreferenceInfo();
    await loadHistory();
    noteBookCompleter.complete();
  }

  Future<void> deleteNote(String uid) async{
    dirRemoveChild(notebookItems[uid].value.parentUid, uid);
    if(preferenceInfo.lastOpenedNote.remove(uid)){
      noteRepository.savePreferenceInfo(preferenceInfo);
    }

    notebookItems.remove(uid);
    await noteRepository.deleteNote(uid);
  }

  Future<void> deleteDir(String uid) async{
    notebookItems.remove(uid);
    await noteRepository.deleteDirectory(uid);
  }

  Future<Rx<Note>> loadNote(String uid) async {
    if (notebookItems.containsKey(uid)) return notebookItems[uid];
    var note = await noteRepository.getNote(uid);
    var rNote = note.obs;
    notebookItems[uid] = rNote;
    return notebookItems[uid];
  }

  Future<void> loadHistory() async {
    for (var child in preferenceInfo.lastOpenedNote) {
      await loadNote(child);
    }
  }

  Future<Rx<Directory>> loadDir(String uid, {bool recurse = true}) async {
    Directory dir;
    try {
      dir = await noteRepository.getDirectory(uid);
    } catch (e) {
      if (uid == 'directory-root') {
        dir = Directory(uid: uid, title: 'root');
        refreshDir(dir);
        debugPrint('save dir root');
      } else {
        throw '$uid error when load';
      }
    }
    if (dir.children != null && recurse) {
      for (String uid in dir.children!) {
        if (uid.startsWith('note')) {
          await loadNote(uid);
        } else if (uid.startsWith('directory')) {
          await loadDir(uid, recurse: false);
        }
      }
    }
    var rDir = dir.obs;
    notebookItems[uid] = rDir;
    return rDir;
  }

  Future<void> refreshDir(Directory dir) async {
    if (notebookItems.containsKey(dir)) {
      notebookItems[dir].refresh();
      debugPrint('refresh.... ${dir.children}');
    } else {
      notebookItems[dir.uid] = dir.obs;
    }
    await noteRepository.saveDir(dir);
  }

  Future<void> refreshNoteHistory(String noteUid) async {
    preferenceInfo.lastOpenedNote.addToFirst(noteUid);
    if (preferenceInfo.lastOpenedNote.length > 10) {
      preferenceInfo.lastOpenedNote.removeLast();
    }
    await noteRepository.savePreferenceInfo(preferenceInfo);
  }

  Future<void> refreshNote(Note note) async {
    note.itemAttribute.modifyTime = DateTime.now().millisecondsSinceEpoch;
    if (notebookItems.containsKey(note.uid)) {
      notebookItems[note.uid].refresh();
    } else {
      notebookItems[note.uid] = note.obs;
    }
    await noteRepository.saveNote(note);
  }

  void dirAddChild(String parentDirUid, String noteUid) async {
    //check if noteUid in dir, if not, add it in the dir

    Directory parentDir = notebookItems[parentDirUid].value;
    parentDir.itemAttribute.modifyTime = DateTime.now().millisecondsSinceEpoch;
    if (parentDir.children == null || !(parentDir.children!.contains(noteUid))) {
      parentDir.children ??= [];
      debugPrint('${parentDir.uid} ----- ${parentDir.children}');

      parentDir.children!.add(noteUid);
      refreshDir(parentDir);
    }
  }

  void dirRemoveChild(String parentDirUid, String noteUid) async {
    Directory parentDir = notebookItems[parentDirUid].value;
    if (parentDir.children != null && (parentDir.children!.contains(noteUid))) {
      debugPrint('remove child from dir ${parentDir.uid} ----- ${parentDir.children}');

      parentDir.children!.remove(noteUid);
      refreshDir(parentDir);
    }
    else{
      debugPrint('$noteUid not exist in $parentDirUid when dir remove child');
    }
  }

  void addDir(String parentUid,Directory dir) {
    dirAddChild(parentUid, dir.uid);
    refreshDir(dir);
  }
}
