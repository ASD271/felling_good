import 'dart:convert';

import 'package:felling_good/controllers/controllers.dart';
import 'package:felling_good/controllers/notebook_controller.dart';
import 'package:felling_good/pages/directory_editor_page.dart';
import 'package:felling_good/repository/note_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:note_database/note_database.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:path/path.dart';
import '../../pages/editor_page/editor_page.dart';
import 'package:intl/intl.dart';

import 'note_select_page_controller.dart';

typedef Compare<E> = int Function(E a, E b);

class DirSelectPageController extends GetxController implements NoteOperation {
  // NoteRepository noteRepository = NoteRepository();
  NotebookController get notebookController => GetInstance().find<NotebookController>();

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();
  RxList<String> uids = ([].cast<String>()).obs;
  bool reversed = false;

  @override
  void onInit() async {
    super.onInit();
    await notebookController.noteBookCompleter.future;
    currentDir = await notebookController.loadDir('directory-root');
    getCurrentChildren();
    refreshCurrentChild();
    noteSelectPageController.uidsSort(uids);
    update();
  }

  Compare<String>? sortRule;

  void getCurrentChildren() {
    uids.clear();
    if (currentDir.value.children != null) {
      for (var uid in currentDir.value.children!) {
        uids.add(uid);
      }
    }
  }

  void sortCurrentUids() {
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

  List<String> dirHistory = [];

  void refreshCurrentChild() {
    if (currentDir.value.children != null) {
      itemNums.value = currentDir.value.children!.length;
    } else {
      itemNums.value = 0;
    }
    if (title.value != currentDir.value.title) {
      title.value = currentDir.value.title;
    }
  }

  void addNote() async {
    await Get.to(() => EditorPage(), arguments: [
      {'parentDirUid': currentDir.value.uid}
    ]);
    print('add note back');
    updateDirectory();
  }

  @override
  void openNote(String uid) async {
    await noteSelectPageController.openNote(uid);
    notebookController.notebookItems[uid].refresh();
  }

  @override
  void deleteNote(String uid) async{
    assert(uid.startsWith('note'), 'uid not started with note when remove note');
    await notebookController.deleteNote(uid);
    updateDirectory();
  }

  void updateDirectory() {
    getCurrentChildren();
    refreshCurrentChild();
    noteSelectPageController.uidsSort(uids);
    update();
  }

  @override
  void openDir(String uid) async {
    assert(uid.startsWith('directory'), 'dir uid not right $uid');
    dirHistory.add(currentDir.value.uid);
    currentDir.value = (await notebookController.loadDir(uid)).value;
    debugPrint('$itemNums   ${currentDir.value.children}');
    updateDirectory();
  }

  void editDirectory() async {
    final String uid=currentDir.value.uid;
    await Get.to(() => DirectoryEditorPage(uid));
    debugPrint('after edit');
    updateDirectory();
  }


  @override
  void deleteDir(String uid, {bool outter=true,String? parentUid}) {
    assert(uid.startsWith('directory'), 'uid not started with directory when remove directory');
    Directory dir = notebookController.notebookItems[uid].value;
    if (dir.children != null) {
      for (String child in dir.children!) {
        if (child.startsWith('directory')) {
          deleteDir(child, outter: false,parentUid: uid);
        } else if (child.startsWith('note')) {
          deleteNote(child);
        }
      }
    }

    notebookController.dirRemoveChild(parentUid??currentDir.value.uid, uid);
    notebookController.deleteDir(uid);
    if (outter) updateDirectory();  //update view when after delete dir
  }

  Future<bool> backDirectory() async {
    if (dirHistory.isEmpty) {
      print(dirHistory);
      return false;
    }
    String uid = dirHistory.removeLast();
    currentDir.value = (await notebookController.loadDir(uid)).value;
    updateDirectory();
    return true;
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