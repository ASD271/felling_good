// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'note_structure.dart';
//
// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************
//
// class DirectoryAdapter extends TypeAdapter<Directory> {
//   @override
//   final int typeId = 0;
//
//   @override
//   Directory read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return Directory(
//       uid: fields[0] as String?,
//       title: fields[1] as String?,
//       description: fields[2] as String?,
//       itemAttribute: fields[3] as ItemAttribute?,
//     )
//       ..extensions = (fields[4] as List?)?.cast<String>()
//       ..children = (fields[5] as List?)?.cast<String>();
//   }
//
//   @override
//   void write(BinaryWriter writer, Directory obj) {
//     writer
//       ..writeByte(6)
//       ..writeByte(0)
//       ..write(obj.uid)
//       ..writeByte(1)
//       ..write(obj.title)
//       ..writeByte(2)
//       ..write(obj.description)
//       ..writeByte(3)
//       ..write(obj.itemAttribute)
//       ..writeByte(4)
//       ..write(obj.extensions)
//       ..writeByte(5)
//       ..write(obj.children);
//   }
//
//   @override
//   int get hashCode => typeId.hashCode;
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is DirectoryAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
//
// class NoteAdapter extends TypeAdapter<Note> {
//   @override
//   final int typeId = 1;
//
//   @override
//   Note read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return Note(
//       parentUid: fields[3] as String,
//       jsonContent: fields[2] as String?,
//       uid: fields[0] as String?,
//       itemAttribute: fields[4] as ItemAttribute?,
//       title: fields[1] as String?,
//     )..extensions = (fields[5] as List?)?.cast<String>();
//   }
//
//   @override
//   void write(BinaryWriter writer, Note obj) {
//     writer
//       ..writeByte(6)
//       ..writeByte(0)
//       ..write(obj.uid)
//       ..writeByte(1)
//       ..write(obj.title)
//       ..writeByte(2)
//       ..write(obj.jsonContent)
//       ..writeByte(3)
//       ..write(obj.parentUid)
//       ..writeByte(4)
//       ..write(obj.itemAttribute)
//       ..writeByte(5)
//       ..write(obj.extensions);
//   }
//
//   @override
//   int get hashCode => typeId.hashCode;
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is NoteAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
//
// class TagsAdapter extends TypeAdapter<Tags> {
//   @override
//   final int typeId = 2;
//
//   @override
//   Tags read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return Tags(
//       fields[1] as String,
//       (fields[0] as List).cast<String>(),
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, Tags obj) {
//     writer
//       ..writeByte(2)
//       ..writeByte(0)
//       ..write(obj.tags)
//       ..writeByte(1)
//       ..write(obj.uid);
//   }
//
//   @override
//   int get hashCode => typeId.hashCode;
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is TagsAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
//
// class ItemAttributeAdapter extends TypeAdapter<ItemAttribute> {
//   @override
//   final int typeId = 100;
//
//   @override
//   ItemAttribute read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return ItemAttribute(
//       createTime: fields[0] as int?,
//       modifyTime: fields[1] as int?,
//     )..pined = fields[2] as bool;
//   }
//
//   @override
//   void write(BinaryWriter writer, ItemAttribute obj) {
//     writer
//       ..writeByte(3)
//       ..writeByte(0)
//       ..write(obj.createTime)
//       ..writeByte(1)
//       ..write(obj.modifyTime)
//       ..writeByte(2)
//       ..write(obj.pined);
//   }
//
//   @override
//   int get hashCode => typeId.hashCode;
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is ItemAttributeAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
