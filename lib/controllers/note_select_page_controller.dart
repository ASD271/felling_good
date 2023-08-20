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
    title.value = currentDir.value.title;
    if (currentDir.value.children != null){
      for(String uid in currentDir.value.children!){
        await notebookController.loadNote(uid);
      }
      itemNums.value = currentDir.value.children!.length;
      print( '${currentDir.value.children!}, ${itemNums}');
    }



  }

  late Rx<Directory> currentDir;
  RxInt itemNums = 0.obs;
  RxString title = 'null'.obs;

  void addNote() {
    Get.to(()=>EditorPage(),arguments: [
      {'parentDirUid':currentDir.value.uid}
    ]);
  }

  Rx<Note> getNote(String uid){
    return notebookController.notebookItems[uid];
  }

  Note getN(String uid){
    return notebookController.notebookItems[uid].value!;
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
