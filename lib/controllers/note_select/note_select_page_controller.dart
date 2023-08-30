import 'dart:convert';

import 'package:felling_good/controllers/notebook_controller.dart';
import 'package:felling_good/pages/directory_editor_page.dart';
import 'package:felling_good/repository/note_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:note_database/note_database.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../pages/editor_page/editor_page.dart';
import 'package:felling_good/pages/note_select_page/note_history_page.dart';
import 'package:intl/intl.dart';

part 'sort_rules.dart';

typedef Compare<E> = int Function(E a, E b);

class NoteSelectPageController extends GetxController {
  // NoteRepository noteRepository = NoteRepository();
  NotebookController get notebookController => GetInstance().find<NotebookController>();
  RxList<String> uids = ([].cast<String>()).obs;
  bool reversed = false;

  @override
  void onInit() async {
    super.onInit();
    await notebookController.noteBookCompleter.future;
    // currentDir = await notebookController.loadDir('directory-root');
    getPreference();
    // refreshChild();
    update();
  }

  Compare<String>? sortRule;

  void getPreference() {
    PreferenceInfo preferenceInfo = notebookController.preferenceInfo;
    sortRule = getRuleByString(preferenceInfo.sortRule);
  }

  Compare<String> getRuleByString(String ruleName) {
    if (ruleName == 'default') {
      return sortDefault;
    } else if (ruleName == 'updateTime') {
      return sortUpdateTime;
    } else if (ruleName == 'createTime') {
      return sortCreateTime;
    }
    throw 'rule name not exist';
  }

  void uidsSort(RxList<String> uids) {
    if (uids.isEmpty) return;
    uids.sort(sortRule);
    uids.reversed;
    if (reversed) {
      uids.value = uids.reversed.toList();
    }
  }
  //
  // void sortAccordingRule(Compare<String> rule) {
  //   sortRule = rule;
  //   updateDirectory();
  // }

  // RxInt itemNums = 0.obs;
  // RxString title = ''.obs;

  // List<String> dirHistory = [];

  // void refreshChild() {
  //   if (currentDir.value.children != null) {
  //     itemNums.value = currentDir.value.children!.length;
  //   } else {
  //     itemNums.value = 0;
  //   }
  //   if (title.value != currentDir.value.title) {
  //     title.value = currentDir.value.title;
  //   }
  // }

  // void addNote() {
  //   Get.to(() => EditorPage(), arguments: [
  //     {'parentDirUid': currentDir.value.uid}
  //   ]);
  // }

  // void deleteNote(String uid) {
  //   assert(uid.startsWith('note'), 'uid not started with note when remove note');
  //   notebookController.deleteNote(uid);
  // }
  //
  // void deleteDir(String parentUid,String uid) {
  //   assert(uid.startsWith('directory'), 'uid not started with directory when remove directory');
  //   Directory dir = notebookController.notebookItems[uid].value;
  //   if (dir.children != null) {
  //     for (String child in dir.children!) {
  //       if (child.startsWith('directory')) {
  //         deleteDir(uid,child);
  //       } else if (child.startsWith('note')) {
  //         deleteNote(child);
  //       }
  //     }
  //   }
  //   notebookController.dirRemoveChild(parentUid, uid);
  //   notebookController.deleteDir(uid);
  // }

  Rx<Note> getNote(String uid) {
    if (!uid.startsWith('note')) {
      throw 'note uid not right: $uid';
    }
    return notebookController.notebookItems[uid];
  }

  Rx<Directory> getDir(String uid) {
    if (!uid.startsWith('directory')) {
      throw 'directory uid not right: $uid';
    }
    return notebookController.notebookItems[uid];
  }

  String getDate(int milliseconds) {
    var d = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return DateFormat('yyyy-MM-dd').format(d);
  }

  Future<void> openNote(String uid) async {
    String parentDirUid = notebookController.notebookItems[uid].value.parentUid;
    await Get.to(() => EditorPage(), arguments: [
      {'parentDirUid': parentDirUid, 'noteUid': uid}
    ]);
  }

  void continueLastOpenedNote() {
    PreferenceInfo preferenceInfo = notebookController.preferenceInfo;
    if (preferenceInfo.lastOpenedNote.isNotEmpty) {
      String noteUid = preferenceInfo.lastOpenedNote[0];
      openNote(noteUid);
    }
  }

  Future<void> openHistoryPage() async{
    await Get.to(()=>const NoteHistoryPage());

  }

  String decodeNoteDesc(String jsonContent) {
    if (jsonContent == '') return '';
    var doc = Document.fromJson(jsonDecode(jsonContent));
    return doc.toPlainText().replaceAll('\n', '  ');
  }
  //
  // void editDirectory() {
  //   Get.to(() => const DirectoryEditorPage());
  // }

  // void updateDirectory() {
  //   refreshChild();
  //   uidsGetCurrentChildren();
  //   uidsSort();
  //   update();
  // }

  // void openDirectory(String uid) async {
  //   assert(uid.startsWith('directory'), 'dir uid not right $uid');
  //   dirHistory.add(currentDir.value.uid);
  //   currentDir.value = (await notebookController.loadDir(uid)).value;
  //   debugPrint('$itemNums   ${currentDir.value.children}');
  //   updateDirectory();
  // }
  //
  // Future<bool> backDirectory() async {
  //   if (dirHistory.isEmpty) {
  //     print(dirHistory);
  //     return false;
  //   }
  //   String uid = dirHistory.removeLast();
  //   currentDir.value = (await notebookController.loadDir(uid)).value;
  //   updateDirectory();
  //   return true;
  // }

  Map<String, int> analyseDir(String uid) {
    Directory dir = notebookController.notebookItems[uid].value;
    int numDir = 0, numNote = 0;
    dir.children?.forEach((String element) {
      if (element.startsWith('directory')) {
        numDir++;
      } else if (element.startsWith('note')) {
        numNote++;
      }
    });
    return {'dirNum': numDir, 'noteNum': numNote};
  }
}
