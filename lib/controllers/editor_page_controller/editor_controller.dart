import 'package:felling_good/controllers/editor_page_controller/get_text.dart';
import 'package:felling_good/utils/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:get/get.dart';
import 'package:note_database/note_database.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

import '../../universal_ui/universal_ui.dart';
import '../../widgets/opinion_embed_widget.dart';
import '../../widgets/time_stamp_embed_widget.dart';
import '../notebook_controller.dart';
import '../quill_get_controller.dart';
import 'header.dart';
import 'package:uuid/uuid.dart';

enum _SelectionType {
  none,
  word,
  // line,
}

enum NoteStatus { initial, clean, dirty }

class EditorController extends GetxController {
  RxBool inited = false.obs;

  // NoteRepository noteRepository = NoteRepository();
  NotebookController get notebookController => GetInstance().find<NotebookController>();

  Note get note => notebookController.notebookItems[noteUid].value;
  RxBool showBottomBar = false.obs;

  QuillGetController get quillGetController => GetInstance().find<QuillGetController>();


  @override
  void onInit() async {
    super.onInit();
    // if(kIsWeb){
    //   for (var element in defaultEmbedBuildersWeb) {
    //     embedBuilders.add(element);
    //   }
    // }else{
    //   FlutterQuillEmbeds.builders().forEach((element) {
    //     embedBuilders.add(element);
    //   });
    // }
    Map<String, dynamic> args = Get.arguments[0];
    if (!args.containsKey('parentDirUid')) {
      throw 'parentDirUid not exists';
    }
    parentDirUid = args['parentDirUid'];
    if (args.containsKey('noteUid')) {
      noteUid = args['noteUid'];
    } else {
      parentDirUid = args['parentDirUid'];
      Note tempNote = Note(parentUid: args.getValue('parentUid', parentDirUid));
      noteUid = tempNote.uid;
      notebookController.refreshNote(tempNote,save:false);
    }

    await _loadFromRepository();
    if (args.containsKey('note_offset')) {
      int noteOffset = args['note_offset'];
      moveToPosition(noteOffset);
    }
    editorActions = EditorActions(controller);
    // searchComponent = SearchComponent(controller);
    headerNavigationComponent = HeaderNavigationComponent(controller);
    headerNavigationComponent.updateHeader();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    _timer.cancel();
  }

  late QuillController controller;
  final FocusNode focusNode = FocusNode();
  late final EditorActions editorActions;
  // late final SearchComponent searchComponent;
  late final HeaderNavigationComponent headerNavigationComponent;
  NoteStatus noteStatus = NoteStatus.initial;

  Future<void> _loadFromRepository() async {
    final Document doc;
    if (note.jsonContent != '') {
      final result = note.jsonContent;
      doc = Document.fromJson(jsonDecode(result));
    } else {
      doc = Document()..insert(0, '');
    }
    controller =
        QuillController(document: doc, selection: const TextSelection.collapsed(offset: 0));
    controller.document.changes.listen(_listen);
  }

  void _listen(DocChange event){
      checkNoteInitial();
      noteStatus = NoteStatus.dirty;
      note.jsonContent = jsonEncode(controller.document.toDelta().toJson());
      Document before=Document.fromDelta(event.before);
      int base=0;// be sure that insert will not together with delete at one time
      print('change ${event.change.toList()}');
      // event.change.insert('\n');
      // event.change.push('\n');
      // var delta=Delta()..insert('\n');
      // delta=event.change.compose(delta);
      // delta=delta.compose(event.change);
      // print(delta.toList());
      // var doc=Document.fromDelta(delta);
      // var embeds=controller.document.getEmbedType(base, doc.length);
      // print(embeds);
      try{
        for( var e in event.change.toList()){
          if(e.isInsert){
            int len=e.length!;
            print(e.data);
            try{
              if(e.data is Map){
                var map=e.data as Map<String,dynamic>;
                print('map $map');
                quillGetController.insertEmbedFromJson(map);
              }

            }
            catch(e){
              print(e);
            }
            // print('base:$base len:$len');
            // var embeds=controller.document.getEmbedType(base, len);
            // // print('insert embeds $embeds');
            // quillGetController.embedInsertCallback(embeds);
            // base+=len;
          }
          else {
            int len=e.length!;
            if(e.isDelete){
              var embeds=before.getEmbedType(base,len);
              // print('delete embeds $embeds');
              quillGetController.embedDeleteCallback(embeds);
            }
            base+=len;
          }
        }
      }//todo same like there is a bug when transfer pinying to chinese
      catch(e){
        print(e);
      }

  }



  Future<void> refreshNote() async {
    if (noteStatus == NoteStatus.dirty) {
      noteStatus = NoteStatus.clean;
      await notebookController.refreshNote(note);
      debugPrint('saved');
    }
  }

  void checkNoteInitial() {
    if (noteStatus == NoteStatus.initial) {
      notebookController.dirAddChild(parentDirUid, note.uid);
      notebookController.refreshNoteHistory(note.uid);
    }
  }

  void setTitle(String title) {
    note.title = title;
    checkNoteInitial();
    notebookController.refreshNote(note);
  }

  void titleSubmit(String title) {
    focusNode.requestFocus();
    // moveToPosition(0);
    controller.moveCursorToStart();
  }

  void moveToPosition(int offset, {int? extentOffset}) {
    controller.updateSelection(
        TextSelection(baseOffset: offset, extentOffset: extentOffset ?? offset),
        ChangeSource.LOCAL);
  }

  void back() async {
    if (noteStatus == NoteStatus.dirty) {
      await refreshNote();
    }
    _timer.cancel();
    notebookController.backCallback();
    Get.back();
  }

  void changeMenu() {
    showBottomBar.value = !showBottomBar.value;
  }

  void addOpinion(Opinion opinion){
    notebookController.addOpinion(opinion);
  }
  void deleteOpinion(Opinion opinion){
    notebookController.deleteOpinion(opinion);
  }

}

class EditorActions {
  EditorActions(this.controller);

  final QuillController controller;
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

    if (controller.selection.isCollapsed) {
      _selectionType = _SelectionType.none;
    }

    if (_selectionType == _SelectionType.none) {
      _selectionType = _SelectionType.word;
      _startTripleClickTimer();
      return false;
    }

    if (_selectionType == _SelectionType.word) {
      final child = controller.document.queryChild(
        controller.selection.baseOffset,
      );
      final offset = child.node?.documentOffset ?? 0;
      final length = child.node?.length ?? 0;

      final selection = TextSelection(
        baseOffset: offset,
        extentOffset: offset + length,
      );

      controller.updateSelection(selection, ChangeSource.REMOTE);

      // _selectionType = _SelectionType.line;

      _selectionType = _SelectionType.none;

      _startTripleClickTimer();

      return true;
    }

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

class SearchComponent {
  // late String _text;
  // late TextEditingController _controller;
  // late List<int>? _offsets;
  // late int _index;
  // bool _caseSensitive = false;
  // bool _wholeWord = false;
  //
  // SearchComponent(this.quillController) {
  //   _text = '';
  //   _offsets = null;
  //   _index = 0;
  //   _controller = TextEditingController(text: _text);
  // }
  //
  // final QuillController quillController;

  void findText() {
    // if (_text.isEmpty) {
    //   return;
    // }
    // debugPrint(_text);
    // // setState(() {
    //   _offsets = quillController.document.search(
    //     _text,
    //     caseSensitive: _caseSensitive,
    //     wholeWord: _wholeWord,
    //   );
    //   _index = 0;
    // // });
    // debugPrint(_offsets);
    // if (_offsets!.isNotEmpty) {
    //   _moveToPosition();
    // }
  }

  // void _moveToPosition() {
  //   quillController.updateSelection(
  //       TextSelection(
  //           baseOffset: _offsets![_index], extentOffset: _offsets![_index] + _text.length),
  //       ChangeSource.LOCAL);
  // }

// void _moveToPrevious() {
//   if (_offsets!.isEmpty) {
//     return;
//   }
//   setState(() {
//     if (_index > 0) {
//       _index -= 1;
//     } else {
//       _index = _offsets!.length - 1;
//     }
//   });
//   _moveToPosition();
// }
//
// void _moveToNext() {
//   if (_offsets!.isEmpty) {
//     return;
//   }
//   setState(() {
//     if (_index < _offsets!.length - 1) {
//       _index += 1;
//     } else {
//       _index = 0;
//     }
//   });
//   _moveToPosition();
// }
//
// void _textChanged(String value) {
//   setState(() {
//     _text = value;
//     _offsets = null;
//     _index = 0;
//   });
// }
//
// void _changeCaseSensitivity() {
//   setState(() {
//     _caseSensitive = !_caseSensitive;
//     _offsets = null;
//     _index = 0;
//   });
// }
//
// void _changeWholeWord() {
//   setState(() {
//     _wholeWord = !_wholeWord;
//     _offsets = null;
//     _index = 0;
//   });
// }
}
