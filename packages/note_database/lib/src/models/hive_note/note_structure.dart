// import 'dart:core';
//
// import 'package:hive/hive.dart';
// import 'package:note_database/note_database.dart';
// import 'package:uuid/uuid.dart';
//
// part 'note_structure.g.dart';
//
// ///all data is  saved in hive, and select by uid.
//
// ///a directory contains other directory or notes
// @HiveType(typeId: 0)
// class Directory {
//   ///constructor
//   Directory({String? uid, String? title, String? description, ItemAttribute? itemAttribute})
//       : uid = uid ?? 'directory-${const Uuid().v1()}',
//         title = title ?? '',
//         description = description ?? '',
//         itemAttribute = itemAttribute ?? ItemAttribute();
//
//   ///uid identify directory
//   @HiveField(0)
//   final String uid;
//
//   ///a title of one directory
//   @HiveField(1)
//   String title;
//
//   @HiveField(2)
//   String description;
//
//   @HiveField(3)
//   ItemAttribute itemAttribute;
//
//   ///images or videos to decorate the directory
//   @HiveField(4)
//   List<String>? extensions;
//
//   ///a list of notes or other directory
//   @HiveField(5)
//   List<String>? children;
// }
//
// ///structure of basic note, which is quil format saved in a string,
// ///identify with an uid, and may correlated with many other data,
// ///such as tags and other notes.
// @HiveType(typeId: 1)
// class Note {
//   ///constructor
//   Note(
//       {required this.parentUid,
//       String? jsonContent,
//       String? uid,
//       ItemAttribute? itemAttribute,
//       String? title})
//       : jsonContent = jsonContent ?? '',
//         uid = uid ?? 'note-${const Uuid().v1()}',
//         title = title ?? '',
//         itemAttribute = itemAttribute ?? ItemAttribute();
//
//   Note copyWith(
//       {String? jsonContent,
//       String? uid,
//       ItemAttribute? itemAttribute,
//       String? title,
//       required String parentUid}) {
//     return Note(
//       jsonContent: jsonContent ?? this.jsonContent,
//       uid: uid ?? this.uid,
//       title: title ?? this.title,
//       itemAttribute: itemAttribute ?? this.itemAttribute,
//       parentUid: parentUid,
//     );
//   }
//
//   ///a uid used to select note
//   @HiveField(0)
//   String uid;
//
//   @HiveField(1)
//   String title;
//
//   ///main content saved in hive,for using quil,data was mainly json format
//   @HiveField(2)
//   String jsonContent;
//
//   /// parent directory's uid of this note
//   @HiveField(3)
//   String parentUid;
//
//   @HiveField(4)
//   ItemAttribute itemAttribute;
//
//   ///a note may contain other information such as tag, video, which contains in extensions,
//   ///here extensions contains uid of those resource
//   @HiveField(5)
//   List<String>? extensions;
// }
//
// ///a note could add tags in order to filter.
// @HiveType(typeId: 2)
// class Tags {
//   ///constructor of class Tags, uid and tags is not null
//   Tags(this.uid, this.tags);
//
//   ///a list of tags, which could be easily added by user
//   @HiveField(0)
//   List<String> tags;
//
//   ///a uid to select tags
//   @HiveField(1)
//   String uid;
// }
//
// ///a attribute which directory and note may have
// @HiveType(typeId: 100)
// class ItemAttribute {
//   ///create time
//   @HiveField(0)
//   int createTime;
//
//   ///when the item last modified,saved use millisecondsSinceEpoch
//   @HiveField(1)
//   int modifyTime;
//
//   ///should this item show in top,saved use millisecondsSinceEpoch
//   @HiveField(2)
//   bool pined = false;
//
//   ///constructor
//   ItemAttribute({
//     int? createTime,
//     int? modifyTime,
//   })  : createTime = createTime ?? DateTime.now().millisecondsSinceEpoch,
//         modifyTime = modifyTime ?? DateTime.now().millisecondsSinceEpoch;
// }
