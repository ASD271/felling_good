import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_database/note_database.dart';

import '../repository/note_repository.dart';
import 'notebook_controller.dart';

class DirectoryEditorController extends GetxController {
  String title = '', description = '';
  NotebookController get notebookController => GetInstance().find<NotebookController>();

  @override
  void onInit() async {
    super.onInit();
  }

  void back() {
    Get.back();
  }

  void setTitle(String title) {
    this.title = title;
  }

  void setDescription(String desc) {
    this.description = desc;
  }

  void save() {
    notebookController.addDir(Directory(title: title,description:description));
    print('$title,$description');
    // Get.dialog(AlertDialog(
    //   title: Text('hello'),
    //   content: const Text('data'),
    // ));
    Get.back();
  }
}
