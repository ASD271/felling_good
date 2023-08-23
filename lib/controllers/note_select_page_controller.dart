import 'dart:convert';

import 'package:felling_good/controllers/notebook_controller.dart';
import 'package:felling_good/pages/directory_editor_page.dart';
import 'package:felling_good/repository/note_repository.dart';
import 'package:get/get.dart';
import 'package:note_database/note_database.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../pages/editor_page.dart';
import 'package:intl/intl.dart';

class NoteSelectPageController extends GetxController {
  // NoteRepository noteRepository = NoteRepository();
  NotebookController get notebookController => GetInstance().find<NotebookController>();
  RxList<String> uids=([].cast<String>()).obs;
  @override
  void onInit() async {
    super.onInit();
    currentDir = await notebookController.loadDir('directory-root');
    uidsGetCurrentChildren();
    refreshChild();
    uidsSort();
    update();
  }

  void uidsGetCurrentChildren(){
    uids.clear();
    if(currentDir.value.children!=null) {
      for (var uid in currentDir.value.children!) {
        uids.add(uid);
      }
    }
  }

  void uidsSort(){
    uids.sort();
  }

  late Rx<Directory> currentDir;
  RxInt itemNums = 0.obs;
  RxString title=''.obs;

  List<String> history=[];

  void refreshChild(){
    if(currentDir.value.children!=null) {
      itemNums.value=currentDir.value.children!.length;
    } else {
      itemNums.value=0;
    }
    if(title.value!=currentDir.value.title) {
      title.value=currentDir.value.title;
    }

  }

  void addNote() {
    Get.to(()=>EditorPage(),arguments: [
      {'parentDirUid':currentDir.value.uid}
    ]);
  }

  void deleteNote(String uid){
    assert(uid.startsWith('note'),'uid not started with note when remove note');
    notebookController.dirRemoveChild(currentDir.value.uid, uid);
    notebookController.deleteNote(uid);
  }

  Rx<Note> getNote(String uid){
    if(!uid.startsWith('note')){
      throw 'note uid not right: ${uid}';
    }
    return notebookController.notebookItems[uid];
  }

  Rx<Directory> getDir(String uid){
    if(!uid.startsWith('directory')){
      throw 'directory uid not right: ${uid}';
    }
    return notebookController.notebookItems[uid];
  }

  String getDate(int milliseconds){
    var d=DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return DateFormat('yyyy-MM-dd').format(d);
  }

  void openNote(String uid) async{
    Get.to(()=>EditorPage(),arguments: [
      {'parentDirUid':currentDir.value.uid,'noteUid':uid}
    ]);
  }

  String decodeNoteDesc(String jsonContent){
    // String jsonContent=notebookController.notebookItems[uid].value.jsonConten;
    if(jsonContent=='') return '';
    var doc=Document.fromJson(jsonDecode(jsonContent));
    return doc.toPlainText().replaceAll('\n', '  ');
  }

  void editDirectory() {
    Get.to(()=>DirectoryEditorPage());
  }

  void updateDirectory(){
    refreshChild();
    uidsGetCurrentChildren();
    uidsSort();
    update();
  }

  void openDirectory(String uid) async{
    assert(uid.startsWith('directory'),'dir uid not right ${uid}');
    history.add(currentDir.value.uid);
    currentDir.value=(await notebookController.loadDir(uid)).value;
    print('${itemNums}   ${currentDir.value.children}');
    updateDirectory();
  }

  void backDirectory() async{
    if(history.isEmpty){
      print(history);
      return;
    }
    String uid=history.removeLast();
    currentDir.value=(await notebookController.loadDir(uid)).value;
    updateDirectory();
  }
}
