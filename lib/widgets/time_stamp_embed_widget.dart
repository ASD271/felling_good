import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class TimeStampEmbed extends Embeddable {
  const TimeStampEmbed(
    String value,
  ) : super(timeStampType, value);

  static const String timeStampType = 'timeStamp';

  static TimeStampEmbed fromDocument(Document document) =>
      TimeStampEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

class TimeStampEmbedBuilderWidget extends EmbedBuilder {
  @override
  String get key => 'timeStamp';

  @override
  String toPlainText(Embed embed) {
    return embed.value.data;
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
    return SizedBox(
      width: 400,
      child: ListTile(
        leading:  const Icon(Icons.access_time_rounded),
        title:  Text(node.value.data as String),
      ),
    );
  }
}
