import 'dart:convert';

import 'package:note_database/src/models/note_structure/extensions.dart';
import 'package:note_database/src/models/note_structure/item_attribute.dart';
import 'package:uuid/uuid.dart';

///a attribute which directory and note may have
class Opinion {
  ///constructor
  Opinion({String? content, int? star, ItemAttribute? itemAttribute, String? uid})
      : uid = uid ?? 'opinion-${const Uuid().v1()}',
        content = content ?? '',
        star = star ?? 1,
        itemAttribute = itemAttribute ?? ItemAttribute();

  factory Opinion.fromJson(Map<String, dynamic> json) {
    return Opinion(
      uid: json.getValue<String>('uid'),
      content: json.getValue<String>('content'),
      star: json.getValue<int>('star'),
      itemAttribute: ItemAttribute.fromJson(json['itemAttribute'] as Map<String, dynamic>),
    );
  }

  factory Opinion.fromJsonString(String jsonString) {
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return Opinion.fromJson(jsonMap);
  }

  /// base content stored, typically a sentence
  String content;

  /// how important this content is, from 1 to 10, the higher the more important
  int star;

  /// stored for basic item attribtute
  ItemAttribute itemAttribute;

  /// identifier for this opinion
  String uid;

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'content': content, 'star': star, 'itemAttribute': itemAttribute.toJson()};
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  Opinion copyWith({String? uid, String? content, int? star, ItemAttribute? itemAttribute}) {
    return Opinion(
        uid: uid ?? this.uid,
        content: content ?? this.content,
        star: star ?? this.star,
        itemAttribute: itemAttribute ?? this.itemAttribute);
  }
}
