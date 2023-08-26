import 'dart:convert';

import 'package:felling_good/controllers/notebook_controller.dart';
import 'package:felling_good/pages/directory_editor_page.dart';
import 'package:felling_good/repository/note_repository.dart';
import 'package:get/get.dart';
import 'package:note_database/note_database.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../pages/editor_page/editor_page.dart';
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
    currentDir = await notebookController.loadDir('directory-root');
    uidsGetCurrentChildren();
    refreshChild();
    uidsSort();
    update();
  }

  Compare<String>? sortRule;


  void uidsGetCurrentChildren() {
    uids.clear();
    if (currentDir.value.children != null) {
      for (var uid in currentDir.value.children!) {
        uids.add(uid);
      }
    }
  }

  void uidsSort() {
    if (uids.isEmpty) return;
    uids.sort(sortRule);
    uids.reversed;
    if (reversed) {
      uids.value = uids.reversed.toList();
    }
  }

  void sortAccordingRule(Compare<String> rule) {
    sortRule = rule;
    updateDirectory();
  }

  late Rx<Directory> currentDir;
  RxInt itemNums = 0.obs;
  RxString title = ''.obs;

  List<String> history = [];

  void refreshChild() {
    if (currentDir.value.children != null) {
      itemNums.value = currentDir.value.children!.length;
    } else {
      itemNums.value = 0;
    }
    if (title.value != currentDir.value.title) {
      title.value = currentDir.value.title;
    }
  }

  void addNote() {
    Get.to(() => EditorPage(), arguments: [
      {'parentDirUid': currentDir.value.uid}
    ]);
  }

  void deleteNote(String uid) {
    assert(uid.startsWith('note'), 'uid not started with note when remove note');
    notebookController.dirRemoveChild(currentDir.value.uid, uid);
    notebookController.deleteNote(uid);
  }

  void deleteDir(String uid) {
    assert(uid.startsWith('directory'), 'uid not started with directory when remove directory');
    Directory dir = notebookController.notebookItems[uid].value;
    if (dir.children != null) {
      for (String child in dir.children!) {
        if (child.startsWith('directory')) {
          deleteDir(child);
        } else if (child.startsWith('note')) {
          deleteNote(child);
        }
      }
    }
    notebookController.dirRemoveChild(currentDir.value.uid, uid);
    notebookController.deleteDir(uid);
  }

  Rx<Note> getNote(String uid) {
    if (!uid.startsWith('note')) {
      throw 'note uid not right: ${uid}';
    }
    return notebookController.notebookItems[uid];
  }

  Rx<Directory> getDir(String uid) {
    if (!uid.startsWith('directory')) {
      throw 'directory uid not right: ${uid}';
    }
    return notebookController.notebookItems[uid];
  }

  String getDate(int milliseconds) {
    var d = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return DateFormat('yyyy-MM-dd').format(d);
  }

  void openNote(String uid) async {
    Get.to(() => EditorPage(), arguments: [
      {'parentDirUid': currentDir.value.uid, 'noteUid': uid}
    ]);
  }

  String decodeNoteDesc(String jsonContent) {
    // String jsonContent=notebookController.notebookItems[uid].value.jsonConten;
    if (jsonContent == '') return '';
    var doc = Document.fromJson(jsonDecode(jsonContent));
    return doc.toPlainText().replaceAll('\n', '  ');
  }

  void editDirectory() {
    Get.to(() => DirectoryEditorPage());
  }

  void updateDirectory() {
    refreshChild();
    uidsGetCurrentChildren();
    uidsSort();
    update();
  }

  void openDirectory(String uid) async {
    assert(uid.startsWith('directory'), 'dir uid not right ${uid}');
    history.add(currentDir.value.uid);
    currentDir.value = (await notebookController.loadDir(uid)).value;
    print('${itemNums}   ${currentDir.value.children}');
    updateDirectory();
  }

  Future<bool> backDirectory() async {
    if (history.isEmpty) {
      print(history);
      return false;
    }
    String uid = history.removeLast();
    currentDir.value = (await notebookController.loadDir(uid)).value;
    updateDirectory();
    return true;
  }

  Map<String,int> analyseDir(String uid) {
    Directory dir = notebookController.notebookItems[uid].value;
    int numDir = 0,
        numNote = 0;
    dir.children?.forEach((String element) {
      if (element.startsWith('directory')){
      numDir++;
      }
      else if(element.startsWith('note')) {
        numNote++;
      }});
    return {'dirNum':numDir,'noteNum':numNote};
  }
}
