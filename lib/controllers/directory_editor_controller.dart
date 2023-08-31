import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_database/note_database.dart';

import '../repository/note_repository.dart';
import 'notebook_controller.dart';

class DirectoryEditorController extends GetxController {
  NotebookController get notebookController => GetInstance().find<NotebookController>();
  TextEditingController titleCtr = TextEditingController(), descCtr = TextEditingController();
  late String parentUid;
  String? uid;

  @override
  void onInit() async {
    super.onInit();
    parentUid = Get.arguments['parentUid'];
    debugPrint(parentUid);
    uid = Get.arguments['uid'];
    debugPrint(uid);
    if (uid != null) {
      titleCtr.text = notebookController.notebookItems[uid].value.title;
      descCtr.text = notebookController.notebookItems[uid].value.description;
    }
  }

  void back() {
    Get.back();
  }

  void save() {
    if(uid==null){
      notebookController.addDir(
          parentUid, Directory(title: titleCtr.text, description: descCtr.text));
    }
    else{
      Directory dir=notebookController.notebookItems[uid].value;
      dir..title=titleCtr.text..description=descCtr.text;
      notebookController.refreshDir(dir);
    }

    // print('$title,$description');
    // Get.dialog(AlertDialog(
    //   title: Text('hello'),
    //   content: const Text('data'),
    // ));
    Get.back();
  }
}
