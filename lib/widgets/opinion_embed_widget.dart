import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:note_database/note_database.dart';

class OpinionEmbedWidget extends Embeddable {
  const OpinionEmbedWidget(
    String value,
  ) : super(opinionType, value);

  static const String opinionType = 'opinion';

  static OpinionEmbedWidget fromDocument(Document document) =>
      OpinionEmbedWidget(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

class OpinionEmbedWidgetBuilderWidget extends EmbedBuilder {
  @override
  String get key => 'opinion';

  @override
  String toPlainText(Embed embed) {
    return Opinion.fromJsonString(embed.value.data).content;
  }

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    var opinion = Opinion.fromJsonString(node.value.data);
    return Text(
      opinion.content,
      style: const TextStyle(backgroundColor: Colors.yellow, fontSize: 18),
      softWrap: true,
      textAlign: TextAlign.center,
    );
  }
}
