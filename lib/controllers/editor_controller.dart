import 'package:felling_good/repository/note_repository.dart';
import 'package:get/get.dart';
import 'package:note_database/note_database.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

import 'notebook_controller.dart';
import 'dart:async';

enum _SelectionType {
  none,
  word,
  // line,
}


class EditorController extends GetxController {
  RxBool inited = false.obs;
  // NoteRepository noteRepository = NoteRepository();
  NotebookController get notebookController => GetInstance().find<NotebookController>();
  Note get note=>notebookController.notebookItems[noteUid].value;


  @override
  void onInit() async {

    super.onInit();
    Map<String, dynamic> args = Get.arguments[0];
    if (args.containsKey('noteUid')) {
      noteUid = args['noteUid'];
    } else {
      Note tempNote=Note();
      noteUid = tempNote.uid;
      notebookController.refreshNote(tempNote);
    }
    await _loadFromRepository();
    print('after load');
    // editorActions = EditorActions(controller);
    editorActions = EditorActions();
    parentDirUid=args['parentDirUid'];

    _timer=Timer.periodic(Duration(seconds: 1), (timer){
      refreshNote();
    });
    inited.value = true;
    update();
  }

  late String noteUid;
  late String parentDirUid;
  late Timer _timer;


  @override
  void dispose() {
    super.dispose();
    editorActions.dispose();
  }

  late QuillController controller;
  final FocusNode focusNode = FocusNode();
  late final EditorActions editorActions;
  int dirty=0; // 0 represent not used, 1 represent is not dirty, 2 represent is dirty now

  Future<void> _loadFromRepository() async {
    final Document doc;
    if (note.jsonContent != '') {
      print('load hive');
      final result = note.jsonContent;
      doc = Document.fromJson(jsonDecode(result));
    } else {
      print('load empty');
      doc = Document()..insert(0, '');
    }
    print('new');
    controller =
        QuillController(document: doc, selection: const TextSelection.collapsed(offset: 0));
    print(doc.toDelta().toString());
    print(doc.toPlainText());
    controller.document.changes.listen((DocChange event) {
      if(dirty==0){
        print('dir add note');
        notebookController.dirAddChild(parentDirUid, note.uid);
      }

      note.jsonContent=jsonEncode(controller.document.toDelta().toJson());
      print(controller.document.toDelta().toJson());
      dirty=2;
    });
  }

  Future<void> refreshNote() async{
    // print('running refresh...');
    if(dirty==2){
      dirty=1;
      await notebookController.refreshNote(note);
      print('saved');
    }
  }

  void setTitle(String title){
    note.title=title;
    if(dirty==0){
      print('dir add note');
      notebookController.dirAddChild(parentDirUid, note.uid);
    }
    notebookController.refreshNote(note);
    // dirty=2;
  }

  void back(){
    if(dirty!=0)
    {
      print(notebookController.notebookItems.keys);
      print(notebookController.notebookItems.containsKey(note.uid));
      notebookController.notebookItems[note.uid].value=note;
      refreshNote();
      print('back refresh');
    }
    _timer.cancel();
    Get.back();
  }
}

class EditorActions {
  // EditorActions(this.controller);
  EditorActions();

  // final QuillController controller;
  Timer? _selectAllTimer;
  _SelectionType _selectionType = _SelectionType.none;

  bool onTripleClickSelection() {
    // final controller = editorController.controller!;

    _selectAllTimer?.cancel();
    _selectAllTimer = null;

    // If you want to select all text after paragraph, uncomment this line
    // if (_selectionType == _SelectionType.line) {
    //   final selection = TextSelection(
    //     baseOffset: 0,
    //     extentOffset: controller.document.length,
    //   );

    //   controller.updateSelection(selection, ChangeSource.REMOTE);

    //   _selectionType = _SelectionType.none;

    //   return true;
    // }

    // if (controller.selection.isCollapsed) {
    //   _selectionType = _SelectionType.none;
    // }
    //
    // if (_selectionType == _SelectionType.none) {
    //   _selectionType = _SelectionType.word;
    //   _startTripleClickTimer();
    //   return false;
    // }
    //
    // if (_selectionType == _SelectionType.word) {
    //   final child = controller.document.queryChild(
    //     controller.selection.baseOffset,
    //   );
    //   final offset = child.node?.documentOffset ?? 0;
    //   final length = child.node?.length ?? 0;
    //
    //   final selection = TextSelection(
    //     baseOffset: offset,
    //     extentOffset: offset + length,
    //   );
    //
    //   controller.updateSelection(selection, ChangeSource.REMOTE);
    //
    //   // _selectionType = _SelectionType.line;
    //
    //   _selectionType = _SelectionType.none;
    //
    //   _startTripleClickTimer();
    //
    //   return true;
    // }

    return false;
  }

  void _startTripleClickTimer() {
    _selectAllTimer = Timer(const Duration(milliseconds: 900), () {
      _selectionType = _SelectionType.none;
    });
  }

  void dispose() {
    _selectAllTimer?.cancel();
  }
}
