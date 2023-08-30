import 'package:felling_good/controllers/controllers.dart';
import 'package:felling_good/repository/note_repository.dart';

class NoteHistoryController extends GetxController {
  NotebookController get notebookController => GetInstance().find<NotebookController>();

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();
  PreferenceInfo get preference=>notebookController.preferenceInfo;
  @override
  void onInit() async{
    super.onInit();
    await notebookController.noteBookCompleter.future;
  }
  void openNote(String noteUid) async{
    await noteSelectPageController.openNote(noteUid);
    notebookController.refreshNoteHistory(noteUid);
    update();
  }
}
