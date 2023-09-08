import 'package:felling_good/controllers/editor_page_controller/get_text.dart';
import 'package:felling_good/widgets/opinion_embed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as Quill;
import 'package:note_database/note_database.dart';
import 'package:felling_good/controllers/controllers.dart';
import 'package:get/get.dart';
import 'package:rating_dialog/rating_dialog.dart';

class HighlightButton extends StatelessWidget {
  const HighlightButton(this.controller, {this.afterButtonPressed, Key? key}) : super(key: key);

  // EditorController get editorController => GetInstance().find<EditorController>();
  final Quill.QuillController controller;
  final VoidCallback? afterButtonPressed;

  List<int> getIndexLen(){
    int index = controller.selection.baseOffset;
    int len = controller.selection.extentOffset - controller.selection.baseOffset;
    if(len<0){
      index+=len;
      len=-len;
    }
    return [index,len];
  }

  void insertWidget(String text) {
    controller.document.insert(
      controller.selection.extentOffset,
      OpinionEmbedWidget(text),
    );
    controller.moveCursorToPosition(controller.selection.extentOffset + 1);
  }

  void insertText(String text) {
    controller.document.insert(controller.selection.extentOffset, text);
    controller.moveCursorToPosition(controller.selection.extentOffset + text.length);
  }

  String? getSelectText() {
    var l=getIndexLen();
    int index = l[0];
    int len = l[1];
    if (len == 0||index<0) return null;
    print('embed in this : ${controller.document.getEmbedType(index, len)}');
    return controller.document.getPlainTextWithEmbed(index, len);
  }

  List<String>? getSelectEmbed() {
    var l=getIndexLen();
    int index = l[0];
    int len = l[1];
    if (len == 0||index<0) return null;
    return controller.document.getEmbedType(index, len);
  }

  void deleteSelect() {
    var l=getIndexLen();
    int index = l[0];
    int len = l[1];
    if (len == 0||index<0) return;
    controller.document.delete(index, len);
    controller.moveCursorToPosition(index);
  }

  Future<void> _onPress(BuildContext context) async {
    var embedTypes = getSelectEmbed();
    bool hasOpinion = false;
    if (embedTypes != null) {
      Pattern p = RegExp('^opinion');
      for (var value in embedTypes) {
        if (!value.startsWith(p)) return;
        hasOpinion = true;
      }
    }
    String? text = getSelectText();
    print("text left:$text");

    if (text != null) {
      if (hasOpinion) {
        deleteSelect();
        insertText(text);
      } else {
        int star = await _dialogBuilder(context, text);
        if(star<0){
          return;
        }
        deleteSelect();
        Opinion opinion = Opinion(content: text, star: star);
        insertWidget(opinion.toJsonString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await _onPress(context);
          afterButtonPressed?.call();
        },
        icon: const Icon(Icons.highlight));
  }
}

Future<int> _dialogBuilder(BuildContext context, String content) async{
  int star=-1;
  final _dialog = RatingDialog(
    initialRating: 1.0,
    enableComment: false,
    // your app's name?
    title: Text(
      'highlight'.tr,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    // encourage your user to leave a high rating?
    message: Text(
      content,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 15),
    ),
    // your app's logo?
    // image: const FlutterLogo(size: 100),
    submitButtonText: 'confirm'.tr,
    onCancelled: () => print('cancelled'),
    onSubmitted: (response) {
      print('rating: ${response.rating}, comment: ${response.comment}');
      star=response.rating.round();
      // TODO: add your own logic
      if (response.rating < 3.0) {
        // send their comments to your email or anywhere you wish
        // ask the user to contact you instead of leaving a bad review
      } else {
        // _rateAndReviewApp();
      }
    },
  );
  await showDialog(
    context: context,
    barrierDismissible: false, // set to false if you want to force a rating
    builder: (context) => _dialog,
  );
  return star;
}
