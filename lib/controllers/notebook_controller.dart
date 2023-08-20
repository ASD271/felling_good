import 'package:get/get.dart';
import 'package:note_database/note_database.dart';

import '../repository/note_repository.dart';

class NotebookController extends GetxController {
  RxBool inited = false.obs;
  NoteRepository noteRepository = NoteRepository();
  Map<String, dynamic> notebookItems = {};
  // Map<String, NoteItem> items = {};


  @override
  void onInit() async {
    super.onInit();
  }

  // Future<NoteItem> loadItem(String uid) async {
  //   NoteItem noteItem;
  //   if (uid.startsWith('note')) {
  //     var item = await noteRepository.getNote(uid);
  //     noteItem = NoteItem(item.uid, title: item.title);
  //   } else if (uid.startsWith('directory')) {
  //     var item = await noteRepository.getDirectory(uid);
  //     noteItem = NoteItem(item.uid, title: item.title);
  //   } else {
  //     throw 'not known prefix';
  //   }
  //
  //   items[uid] = noteItem;
  //   return noteItem;
  // }



  Future<Rx<Note>> loadNote(String uid) async {
    var note = await noteRepository.getNote(uid);
    var rNote = note.obs;
    notebookItems[uid] = rNote;
    return notebookItems[uid];
  }

  Future<Rx<Directory>> loadDir(String uid) async {
    var dir = await noteRepository.getDirectory(uid);
    if (uid == 'directory-root') {
      dir = Directory(uid: uid, title: 'root');
      addDir(dir);
      print('save dir root');
    }
    var rDir = dir.obs;
    notebookItems[uid] = rDir;
    return rDir;
  }

  Future<void> addDir(Directory dir) async {
    // if (items.containsKey(dir.uid)) {
    //   items[dir.uid] = NoteItem(dir.uid,title: dir.title,desc: dir.description);
    // } else {
    //   // items[dir.uid] = dir.obs;
    // }
    if(notebookItems.containsKey(dir)){
      notebookItems[dir.uid].value=dir;
      notebookItems[dir].refresh();
    }
    else{
      notebookItems[dir.uid]=dir.obs;
    }
    await noteRepository.saveDir(dir);
  }

  Future<void> addNote(Note note) async {
    if (notebookItems.containsKey(note.uid)) {
      // Note x = note.copyWith();
      // items[note.uid].value = x;
      // print('${items[note.uid].value.title} and ${note.title}');
      //
      // print('save note but null.');
      // note[note.uid] = NoteItem(note.uid,title: note.title);
      // notebookItems[note.uid].value = note;
      notebookItems[note.uid].refresh();
      print('contains    ${note.uid}');
    } else {
      notebookItems[note.uid] = note.obs;
      print('not containds');
    }
    // await noteRepository.saveNote(note);
  }

  void dirAddChild(String dirUid, String noteUid) async{
    //check if noteUid in dir, if not, add it in the dir
    print(dirUid);
    Directory dir = await noteRepository.getDirectory(dirUid);
    if (dir.children == null || !(dir.children!.contains(noteUid))) {
      dir.children ??= [];
      print('${dir.uid}   ${dir.children}');

      dir.children!.add(noteUid);
      addDir(dir);
    }
  }
}

class NoteItem {
  NoteItem(this.uid, {String? title, String? desc})
      : title = RxString(title ?? ''),
        desc = RxString(desc ?? '');
  RxString title;
  RxString desc;
  final String uid;
}
