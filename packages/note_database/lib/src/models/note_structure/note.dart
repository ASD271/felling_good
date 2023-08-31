import 'dart:convert';

import 'package:uuid/uuid.dart';

import 'item_attribute.dart';
import 'extensions.dart';

/// note structure
class Note {
  ///constructor
  Note(
      {required this.parentUid,
      String? jsonContent,
      String? uid,
      ItemAttribute? itemAttribute,
      String? title,
      this.extensions})
      : jsonContent = jsonContent ?? '',
        uid = uid ?? 'note-${const Uuid().v1()}',
        title = title ?? '',
        itemAttribute = itemAttribute ?? ItemAttribute();

  factory Note.fromJsonString(String json){
    var jsonMap=jsonDecode(json) as Map<String,dynamic>;
    return Note.fromJson(jsonMap);
  }
  String toJsonString(){
    return jsonEncode(toJson());
  }

  ///a uid used to select note
  String uid;

  ///title of a note
  String title;

  ///main content which has been transfer to json string,
  ///which is editor agnostic
  String jsonContent;

  /// parent directory's uid of this note
  String parentUid;

  /// shared between directory and note
  ItemAttribute itemAttribute;

  ///a note may contain other information such as tag, video, which contains in extensions,
  ///here extensions contains uid of those resource
  List<String>? extensions;

  /// load from json map
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      parentUid: json.getValue<String>('parentUid')!,
      jsonContent: json.getValue<String>('jsonContent'),
      uid: json.getValue<String>('uid'),
      title: json.getValue<String>('title'),
      itemAttribute: ItemAttribute.fromJson(json['itemAttribute'] as Map<String, dynamic>),
      extensions: json.getListValue<String>('extensions'),
    );
  }

  /// convert to json map
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'parentUid': parentUid,
      'jsonContent': jsonContent,
      'uid': uid,
      'title': title,
      'itemAttribute': itemAttribute,
      'extensions': extensions,
    };
  }

  /// only change parameter which has been added
  Note copyWith({
    String? parentUid,
    String? jsonContent,
    String? uid,
    ItemAttribute? itemAttribute,
    String? title,
    List<String>? extensions,
  }) {
    return Note(
      parentUid: parentUid ?? this.parentUid,
      jsonContent: jsonContent ?? this.jsonContent,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      itemAttribute: itemAttribute ?? this.itemAttribute,
      extensions: extensions ?? this.extensions,
    );
  }
}
