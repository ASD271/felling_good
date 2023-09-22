import 'package:felling_good/controllers/note_select/note_select_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:felling_good/controllers/controllers.dart';
import 'package:get/get.dart';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';


import '../../widgets/time_stamp_embed_widget.dart';

class EditorBar extends StatelessWidget implements PreferredSize {
  EditorController get editorController => GetInstance().find<EditorController>();
  // NoteSelectPageController get noteSelectPageController => GetInstance().find<NoteSelectPageController>();
  // DirSelectPageController get dirSelectPageController => GetInstance().find<DirSelectPageController>();
  const EditorBar({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      // title: Text(
      //   dirSelectPageController.currentDir.value.title
      // ),
      actions: [
        // IconButton(
        //   onPressed: () => _insertTimeStamp(
        //     editorController.controller,
        //     DateTime.now().toString(),
        //   ),
        //   icon: const Icon(Icons.add_alarm_rounded),
        // ),
        // IconButton(
        //   onPressed: () => showDialog(
        //     context: context,
        //     builder: (context) => AlertDialog(
        //       content: Text(editorController.controller.document.toPlainText(
        //           [...FlutterQuillEmbeds.builders(), TimeStampEmbedBuilderWidget()])),
        //     ),
        //   ),
        //   icon: const Icon(Icons.text_fields_rounded),
        // ),
        IconButton(
            onPressed: () => editorController.back(), icon: const Icon(Icons.arrow_back)),
        IconButton(
            onPressed: () => editorController.changeMenu(),
            icon: Icon(Icons.menu)),
      ],
    );
  }
  static void _insertInNewLine(QuillController controller,Embeddable embeddable){
    controller.document.insert(controller.selection.extentOffset, '\n');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );

    controller.document.insert(
      controller.selection.extentOffset,
      embeddable,
    );

    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );

    controller.document.insert(controller.selection.extentOffset, ' ');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );

    controller.document.insert(controller.selection.extentOffset, '\n');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );
  }
  static void _insertTimeStamp(QuillController controller, String string) {
    _insertInNewLine(controller, TimeStampEmbed(string));
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();
}
