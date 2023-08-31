import 'dart:convert';

import 'package:note_database/src/models/note_structure/extensions.dart';
///a attribute which directory and note may have
class ItemAttribute {

  ///constructor
  ItemAttribute({
    int? createTime,
    int? modifyTime,
    this.pined = false,
  })  : createTime = createTime ?? DateTime.now().millisecondsSinceEpoch,
        modifyTime = modifyTime ?? DateTime.now().millisecondsSinceEpoch;

  ///get value from json map
  factory ItemAttribute.fromJson(Map<String, dynamic> json) {
    return ItemAttribute(
      createTime: json.getValue<int>('createTime'),
      modifyTime: json.getValue<int>('modifyTime'),
      pined: json.getValue<bool>('pined', false)!,
    );
  }
  factory ItemAttribute.fromJsonString(String json){
    var jsonMap=jsonDecode(json) as Map<String,dynamic>;
    return ItemAttribute.fromJson(jsonMap);
  }
  String toJsonString(){
    return jsonEncode(toJson());
  }

  ///create time
  int createTime;

  ///when the item last modified,saved use millisecondsSinceEpoch
  int modifyTime;

  ///should this item show in top,saved use millisecondsSinceEpoch
  bool pined;

  Map<String, dynamic> toJson() {
    return {
      'createTime': createTime,
      'modifyTime': modifyTime,
      'pined': pined,
    };
  }

  ItemAttribute copyWith({
    int? createTime,
    int? modifyTime,
    bool? pined,
  }) {
    return ItemAttribute(
      createTime: createTime ?? this.createTime,
      modifyTime: modifyTime ?? this.modifyTime,
      pined: pined ?? this.pined,
    );
  }
}