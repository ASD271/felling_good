import 'package:felling_good/controllers/notebook_controller.dart';
import 'package:felling_good/pages/directory_editor_page.dart';
import 'package:felling_good/repository/note_repository.dart';
import 'package:get/get.dart';
import 'package:note_database/note_database.dart';
import '../pages/editor_page.dart';

class NoteSelectPageController extends GetxController {
  // NoteRepository noteRepository = NoteRepository();
  NotebookController get notebookController => GetInstance().find<NotebookController>();
  RxList<String> uids=([].cast<String>()).obs;
  @override
  void onInit() async {
    super.onInit();
    currentDir = await notebookController.loadDir('directory-root');
    refresh();
  }

  late Rx<Directory> currentDir;
  RxInt itemNums = 0.obs;
  RxString title=''.obs;

  void refresh(){
    if(currentDir.value.children!=null)
      itemNums.value=currentDir.value.children!.length;
    if(title.value!=currentDir.value.title)
      title.value=currentDir.value.title;
  }

  void addNote() {
    Get.to(()=>EditorPage(),arguments: [
      {'parentDirUid':currentDir.value.uid}
    ]);
  }

  Rx<Note> getNote(String uid){
    return notebookController.notebookItems[uid];
  }

  void openNote(String uid) async{
    Get.to(()=>EditorPage(),arguments: [
      {'parentDirUid':currentDir.value.uid,'noteUid':uid}
    ]);
  }

  void addDirectory() {
    Get.to(()=>DirectoryEditorPage());
  }
}
