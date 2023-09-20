import 'dart:convert';

import 'package:note_database/src/models/note_structure/directory.dart';
import 'package:note_database/src/models/note_structure/item_attribute.dart';
import 'package:note_database/src/models/note_structure/note.dart';

void main(){
  ItemAttribute itemAttribute=ItemAttribute(createTime: 1,modifyTime: 2,pined: false);
  var x=itemAttribute.toJson();
  var xx=jsonEncode(x);
  var xxx=jsonDecode(xx) as Map<String,dynamic>;

  var y=ItemAttribute.fromJson(xxx);
  print(y.createTime);
  print(y.modifyTime);
  print(y.pined);
  // var d=Directory(uid:'1',title:'xx',description: '333',itemAttribute: y,extensions: ['hehe','again']);
  // var z=d.toJson();
  // var zz=jsonEncode(z);
  // var zzz=jsonDecode(zz) as Map<String,dynamic>;
  // var k=Directory.fromJson(zzz);
  // print(k);
  // print(k.title);
  // print(k.itemAttribute.modifyTime);
  // print(k.extensions);
  var n=Note(parentUid: '12',jsonContent: '123',extensions: ['hehe']);
  var c=n.toJson();
  var cc=jsonEncode(c);
  var ccc=jsonDecode(cc) as Map<String,dynamic>;
  print(ccc);
  var n2=Note.fromJson(ccc);
  print(n2.extensions);
  print(n2.itemAttribute.modifyTime);
}