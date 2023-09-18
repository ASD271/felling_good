import 'dart:convert';

import 'package:felling_good/controllers/notebook_controller.dart';
import 'package:felling_good/repository/note_repository.dart';
import 'package:get/get.dart';
import 'package:note_database/note_database.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../pages/editor_page/editor_page.dart';
import 'package:felling_good/pages/note_select_page/note_history_page.dart';
import 'package:intl/intl.dart';

part 'sort_rules.dart';

typedef Compare<E> = int Function(E a, E b);

class NoteSelectPageController extends GetxController {
  NotebookController get notebookController => GetInstance().find<NotebookController>();

  @override
  void onInit() async {
    super.onInit();
    await notebookController.noteBookCompleter.future;
    getPreference();
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
    notebookController.refreshOpinion();
    await Get.to(()=>const NoteHistoryPage());

  }

  String decodeNoteDesc(String jsonContent) {
    if (jsonContent == '') return '';
    var doc = Document.fromJson(jsonDecode(jsonContent));
    return doc.toPlainText().replaceAll('\n', '  ');
  }

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
