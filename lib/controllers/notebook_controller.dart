import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:felling_good/controllers/controllers.dart';
import 'package:felling_good/controllers/editor_page_controller/get_text.dart';
import 'package:felling_good/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:note_database/note_database.dart';

import '../repository/note_repository.dart';
import 'note_select/note_select_page_controller.dart';

class NotebookController extends GetxController {
  RxBool inited = false.obs;
  NoteRepository noteRepository = NoteRepository();

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();
  QuillGetController get quillGetController => GetInstance().find<QuillGetController>();
  Map<String, dynamic> notebookItems = {};
  List<Opinion> opinions=[];
  Rx<Opinion> showedOpinion=Opinion(content: 'hello world').obs;
  late PreferenceInfo preferenceInfo;
  Completer<void> noteBookCompleter = Completer();

  @override
  void onInit() async {
    super.onInit();
    preferenceInfo = await noteRepository.getPreferenceInfo();
    await loadHistory();
    await loadOpinions();
    showedOpinion.value=getRandomOpinion();
    noteBookCompleter.complete();
  }

  Future<void> loadOpinions() async{
    opinions.clear();
    var opinionKeys=await noteRepository.getOpinionKeys();
    for(var key in opinionKeys){
      loadOpinion(key);
    }
  }
  Future<Opinion> loadOpinion(String uid) async{
    var opinion = await noteRepository.getOpinion(uid);
    if(!opinions.contains(opinion)){
      opinions.add(opinion);
    }
    return opinion;
  }
  //
  // void embedDeleteCallback(List<String> embeds){
  //   for(var embed in embeds){
  //     if(embed.startsWith('opinion')){
  //       var json=embed.split('|')[1];
  //       Opinion opinion=Opinion.fromJsonString(json);
  //       deleteOpinion(opinion);
  //       print('delete opinion ${opinion.content}');
  //     }
  //   }
  // }
  // void embedInsertCallback(List<String> embeds){
  //   for(var embed in embeds){
  //     if(embed.startsWith('opinion')){
  //       var json=embed.split('|')[1];
  //       Opinion opinion=Opinion.fromJsonString(json);
  //       addOpinion(opinion);
  //       print('add opinion ${opinion.content}');
  //     }
  //   }
  // }

  Future<void> deleteNote(String uid) async{
    dirRemoveChild(notebookItems[uid].value.parentUid, uid);
    if(preferenceInfo.lastOpenedNote.remove(uid)){
      noteRepository.savePreferenceInfo(preferenceInfo);
    }

    Note note=notebookItems[uid].value;
    final result = note.jsonContent;
    var doc = Document.fromJson(jsonDecode(result));
    var embeds=doc.getEmbedType(0,doc.length);
    quillGetController.embedDeleteCallback(embeds);

    notebookItems.remove(uid);
    await noteRepository.deleteNote(uid);
  }

  Future<void> deleteDir(String uid) async{
    notebookItems.remove(uid);
    await noteRepository.deleteDirectory(uid);
  }

  Future<Rx<Note>> loadNote(String uid) async {
    if (notebookItems.containsKey(uid)) return notebookItems[uid];
    var note = await noteRepository.getNote(uid);
    var rNote = note.obs;
    notebookItems[uid] = rNote;
    return notebookItems[uid];
  }

  Future<void> loadHistory() async {
    for (var child in preferenceInfo.lastOpenedNote) {
      await loadNote(child);
    }
  }

  Future<Rx<Directory>> loadDir(String uid, {bool recurse = true}) async {
    Directory dir;
    try {
      dir = await noteRepository.getDirectory(uid);
    } catch (e) {
      if (uid == 'directory-root') {
        dir = Directory(uid: uid, title: 'root');
        refreshDir(dir);
        debugPrint('save dir root');
      } else {
        throw '$uid error when load';
      }
    }
    if (dir.children != null && recurse) {
      for (String uid in dir.children!) {
        if (uid.startsWith('note')) {
          await loadNote(uid);
        } else if (uid.startsWith('directory')) {
          await loadDir(uid, recurse: false);
        }
      }
    }
    var rDir = dir.obs;
    notebookItems[uid] = rDir;
    return rDir;
  }

  Future<void> refreshDir(Directory dir) async {
    if (notebookItems.containsKey(dir.uid)) {
      notebookItems[dir.uid].refresh();
      debugPrint('refresh.... ${dir.children}');
    } else {
      notebookItems[dir.uid] = dir.obs;
    }
    await noteRepository.saveDir(dir);
  }

  Future<void> refreshNoteHistory(String noteUid) async {
    preferenceInfo.lastOpenedNote.addToFirst(noteUid);
    if (preferenceInfo.lastOpenedNote.length > 10) {
      preferenceInfo.lastOpenedNote.removeLast();
    }
    await noteRepository.savePreferenceInfo(preferenceInfo);
  }

  Future<void> refreshNote(Note note,{save=true}) async {
    note.itemAttribute.modifyTime = DateTime.now().millisecondsSinceEpoch;
    if (notebookItems.containsKey(note.uid)) {
      notebookItems[note.uid].refresh();
    } else {
      notebookItems[note.uid] = note.obs;
    }
    if(save) {
      await noteRepository.saveNote(note);
    }
  }

  void dirAddChild(String parentDirUid, String noteUid) async {
    //check if noteUid in dir, if not, add it in the dir

    Directory parentDir = notebookItems[parentDirUid].value;
    parentDir.itemAttribute.modifyTime = DateTime.now().millisecondsSinceEpoch;
    if (parentDir.children == null || !(parentDir.children!.contains(noteUid))) {
      parentDir.children ??= [];
      debugPrint('${parentDir.uid} ----- ${parentDir.children}');

      parentDir.children!.add(noteUid);
      refreshDir(parentDir);
    }
  }

  void dirRemoveChild(String parentDirUid, String noteUid) async {
    Directory parentDir = notebookItems[parentDirUid].value;
    if (parentDir.children != null && (parentDir.children!.contains(noteUid))) {
      debugPrint('remove child from dir ${parentDir.uid} ----- ${parentDir.children}');

      parentDir.children!.remove(noteUid);
      refreshDir(parentDir);
    }
    else{
      debugPrint('$noteUid not exist in $parentDirUid when dir remove child');
    }
  }

  void addDir(String parentUid,Directory dir) {
    dirAddChild(parentUid, dir.uid);
    refreshDir(dir);
  }

  void addOpinion(Opinion opinion){
    int exists=-1;
    for(int i=0;i<opinions.length;i++){
      if(opinions[i].uid==opinion.uid){
        exists=i;
        break;
      }
    }
    if(exists==-1){
      noteRepository.saveOpinion(opinion);
      opinions.add(opinion);
      print('opinion ${opinion.content} add at hive');
    }
    else{
      print('before add ${opinions[exists].star}');
      opinions[exists].star+=opinion.star;
      opinions[exists].itemAttribute.modifyTime=DateTime.timestamp().millisecondsSinceEpoch;
      noteRepository.saveOpinion(opinions[exists]);
      print('opinion ${opinions[exists].content}  has star: ${opinions[exists].star} when add'
          'which has star${opinion.star}');
    }

  }
  void deleteOpinion(Opinion opinion){
    for(int i=0;i<opinions.length;i++){
      if(opinions[i].uid==opinion.uid){
        if(opinions[i].star-opinion.star<=0){
          opinions.removeAt(i);
          noteRepository.deleteOpinion(opinion.uid);
          print('opinion ${opinion.content} delete at hive');
        }
        else if(opinions[i].star-opinion.star>0){
          opinions[i].star-=opinion.star;
          opinions[i].itemAttribute.modifyTime=DateTime.timestamp().millisecondsSinceEpoch;
          noteRepository.saveOpinion(opinions[i]);
          print('opinion ${opinions[i].content}  left star: ${opinions[i].star} when delete');
        }
      }
    }
  }

  Opinion getRandomOpinion() {
    int totalWeight = opinions.fold(0, (prev, opinion) => prev + opinion.star);

    if(totalWeight==0){
      return Opinion(content: 'hello world');
    }
    int random = Random().nextInt(totalWeight);
    print('weight: $totalWeight and random: $random');
    print(opinions);
    int i;
    for (i = 0; i < opinions.length; i++) {
      if (random < opinions[i].star) {
        print('now show : ${opinions[i].content}');
        return opinions[i];
      }
      random = random - opinions[i].star;
    }
    return opinions[i - 1]; //这里几乎不可能运行到，除非你的权重有负数
  }

  void backCallback(){
    showedOpinion.value=getRandomOpinion();
    showedOpinion.refresh();
  }
}
