import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'item_attribute.dart';
import 'extensions.dart';
import 'package:note_database/src/models/note_structure/note_structure.dart';

/// directory structure, which contains other directory or note
class Directory{

  factory Directory.fromJson(Map<String, dynamic> json) {
    return Directory(
      uid: json.getValue<String>('uid'),
      title: json.getValue<String>('title'),
      description: json.getValue<String>('description'),
      itemAttribute: ItemAttribute.fromJson(json['itemAttribute'] as Map<String, dynamic>),
      extensions: json.getListValue<String>('extensions'),
      children: json.getListValue<String>('children'),
    );
  }
  factory Directory.fromJsonString(String json){
    var jsonMap=jsonDecode(json) as Map<String,dynamic>;
    return Directory.fromJson(jsonMap);
  }
  ///constructor
  Directory(
      {String? uid,
      String? title,
      String? description,
      ItemAttribute? itemAttribute,
      this.extensions,
      this.children})
      : uid = uid ?? 'directory-${const Uuid().v1()}',
        title = title ?? '',
        description = description ?? '',
        itemAttribute = itemAttribute ?? ItemAttribute();

  ///uid identify directory
  final String uid;

  ///a title of one directory
  String title;

  ///description of this directory
  String description;

  ///attribute, such as create time and update time
  ItemAttribute itemAttribute;

  ///images or videos to decorate the directory
  List<String>? extensions;

  ///a list of notes or other directory
  List<String>? children;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'title': title,
      'description': description,
      'itemAttribute': itemAttribute,
      'extensions': extensions,
      'children': children,
    };
  }

  String toJsonString(){
    return jsonEncode(toJson());
  }

  Directory copyWith({
    String? uid,
    String? title,
    String? description,
    ItemAttribute? itemAttribute,
    List<String>? extensions,
    List<String>? children,
  }) {
    return Directory(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      itemAttribute: itemAttribute ?? this.itemAttribute,
      extensions: extensions ?? this.extensions,
      children: children ?? this.children,
    );
  }

}
