import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:math' as math;
import 'package:flutter_quill/src/models/documents/nodes/line.dart';
import 'package:flutter_quill/src/models/documents/document.dart';
import 'package:felling_good/widgets/opinion_embed_widget.dart';
import 'package:felling_good/controllers/controllers.dart';

extension DocGetTextWithEmbed on Document{
  String getPlainTextWithEmbed(int index, int len) {
    final res = queryChild(index);
    return (res.node as Line).getPlainTextWithEmbed(res.offset, len);
  }

  List<String> getEmbedType(int index,int len){
    final res = queryChild(index);
    print('index:$index, len:$len $length');
    return (res.node as Line).getEmbedType(res.offset, len);
  }
}

extension LineGetTextWithEmbed on Line{
  String getPlainTextWithEmbed(int offset, int len) {
    final plainText = StringBuffer();
    _getPlainTextWithEmbed(offset, len, plainText);
    return plainText.toString();
  }
  List<String> getEmbedType(int offset, int len) {
    final res = <String>[];
    _getEmbedType(offset, len, res);
    return res;
  }

  int _getNodeTextWithEmbed(Leaf node, StringBuffer buffer, int offset, int remaining) {
    var controller=GetInstance().find<QuillGetController>();
    final text = node.toPlainText(controller.embedBuilders);
    // print('node value ${node.value} and text $text  remaining: $remaining ');
    // print('node runnning type ${node.runtimeType}  bool: ${node.runtimeType==Embed}');
    // print('node running type ${node.runtimeType}  type: ${(node as Embed).value.type }');
    if(node.runtimeType==Embed){
      buffer.write(text);
      return remaining-1;
    }
    if (text == Embed.kObjectReplacementCharacter) {
      return remaining - node.length;
    }

    final end = math.min(offset + remaining, text.length);
    buffer.write(text.substring(offset, end));
    return remaining - (end - offset);
  }
  int _getNodeEmbedType(Leaf node, List<String> embedTypes, int offset, int remaining) {
    var controller=GetInstance().find<QuillGetController>();
    final text = node.toPlainText(controller.embedBuilders);
    // print('node value ${node.value} and text $text  remaining: $remaining ');
    // print('node runnning type ${node.runtimeType}  bool: ${node.runtimeType==Embed}');

    if(node.runtimeType==Embed){
      print('node running type ${node.runtimeType}  type: ${(node as Embed).value.type }');
      print('data : ${(node as Embed).value.data }');
      var value=(node as Embed).value;
      embedTypes.add('${value.type}|${value.data}');
      return remaining-1;
    }
    if (text == Embed.kObjectReplacementCharacter) {
      return remaining - node.length;
    }


    final end = math.min(offset + remaining, text.length);
    return remaining - (end - offset);
  }

  int _getPlainTextWithEmbed(int offset, int len, StringBuffer plainText) {
    var _len = len;
    final data = queryChild(offset, false);
    var node = data.node as Leaf?;

    while (_len > 0) {
      if (node == null) {
        // blank line
        plainText.write('\n');
        _len -= 1;
      } else {
        _len = _getNodeTextWithEmbed(node, plainText, offset - node.offset, _len);

        while (!node!.isLast && _len > 0) {
          node = node.next as Leaf;
          _len = _getNodeTextWithEmbed(node, plainText, 0, _len);
        }

        if (_len > 0) {
          // end of this line
          plainText.write('\n');
          _len -= 1;
        }
      }

      if (_len > 0 && nextLine != null) {
        _len = nextLine!._getPlainTextWithEmbed(0, _len, plainText);
      }
    }

    return _len;
  }

  int _getEmbedType(int offset, int len, List<String> embedTypes) {
    var _len = len;
    final data = queryChild(offset, false);
    var node = data.node as Leaf?;

    while (_len > 0) {
      if (node == null) {
        // blank line
        _len -= 1;
      } else {
        _len = _getNodeEmbedType(node, embedTypes, offset - node.offset, _len);

        while (!node!.isLast && _len > 0) {
          node = node.next as Leaf;
          _len = _getNodeEmbedType(node, embedTypes, 0, _len);
        }

        if (_len > 0) {
          // end of this line
          _len -= 1;
        }
      }

      if (_len > 0 && nextLine != null) {
        _len = nextLine!._getEmbedType(0, _len, embedTypes);
      }
    }

    return _len;
  }
}