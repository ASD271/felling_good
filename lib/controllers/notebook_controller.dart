import 'package:get/get.dart';
import 'package:note_database/note_database.dart';

import '../repository/note_repository.dart';
import 'note_select_page_controller.dart';

class NotebookController extends GetxController {
  RxBool inited = false.obs;
  NoteRepository noteRepository = NoteRepository();
  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();
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

  Future<Rx<Directory>> loadDir(String uid, {bool recurse = true}) async {
    Directory dir;
    try {
      dir = await noteRepository.getDirectory(uid);
    } catch (e) {
      if (uid == 'directory-root') {
        dir = Directory(uid: uid, title: 'root');
        refreshDir(dir);
        print('save dir root');
      }
      else{
        throw '$uid error when load';
      }
    }
    if (dir.children != null&&recurse){
      for(String uid in dir.children!){
        if(uid.startsWith('note'))
          await loadNote(uid);
        if(uid.startsWith('directory'))
          await loadDir(uid,recurse: false);
      }

    }
    var rDir = dir.obs;
    notebookItems[uid] = rDir;
    return rDir;
  }

  Future<void> refreshDir(Directory dir) async {
    // if (items.containsKey(dir.uid)) {
    //   items[dir.uid] = NoteItem(dir.uid,title: dir.title,desc: dir.description);
    // } else {
    //   // items[dir.uid] = dir.obs;
    // }
    // dirAddChild(noteSelectPageController.currentDir.value.uid, dir.uid);
    if (notebookItems.containsKey(dir)) {
      notebookItems[dir].refresh();
      print('refresh.... ${dir.children}');
    } else {
      notebookItems[dir.uid] = dir.obs;
    }
    await noteRepository.saveDir(dir);
  }

  Future<void> refreshNote(Note note) async {
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
    await noteRepository.saveNote(note);
  }

  void dirAddChild(String parentDirUid, String noteUid) async {
    //check if noteUid in dir, if not, add it in the dir

    Directory parentDir = notebookItems[parentDirUid].value;
    print('$parentDirUid  ready... ${parentDir.children}');
    if (parentDir.children == null || !(parentDir.children!.contains(noteUid))) {
      parentDir.children ??= [];
      print('${parentDir.uid} ----- ${parentDir.children}');

      parentDir.children!.add(noteUid);
      refreshDir(parentDir);
      noteSelectPageController.refresh();
    }
  }

  void addDir(Directory dir){
    dirAddChild(noteSelectPageController.currentDir.value.uid, dir.uid);
    refreshDir(dir);
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
