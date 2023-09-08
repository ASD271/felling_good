import 'package:felling_good/controllers/controllers.dart';
import 'package:felling_good/repository/note_repository.dart';

class NoteHistoryController extends NoteSelectController {
  NotebookController get notebookController => GetInstance().find<NotebookController>();

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();
  PreferenceInfo get preference=>notebookController.preferenceInfo;
  @override
  void onInit() async{
    super.onInit();
    await notebookController.noteBookCompleter.future;
    updateUids();
  }
  void updateUids(){
    uids.clear();
    for(var child in notebookController.preferenceInfo.lastOpenedNote){
      uids.add(child);
    }
    itemNums.value=uids.length;
    update();
  }

  @override
  void openNote(String uid) async{
    await noteSelectPageController.openNote(uid);
    notebookController.notebookItems[uid].refresh();
  }

  @override
  void deleteNote(String uid) async {
    assert(uid.startsWith('note'), 'uid not started with note when remove note');
    await notebookController.deleteNote(uid);
    updateUids();
  }

  void back() async{
    notebookController.backCallback();
    Get.back();
  }

  @override
  void deleteDir(String uid) {
    // TODO: implement deleteDir
  }

  @override
  void openDir(String uid) {
    // TODO: implement openDir
  }

  @override
  String getTip() {
    return notebookController.getRandomOpinion().content;
  }
}
