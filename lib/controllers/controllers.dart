import 'package:felling_good/controllers/directory_editor_controller.dart';
import 'package:felling_good/controllers/note_select_page_controller.dart';
import 'package:felling_good/controllers/notebook_controller.dart';
import 'package:get/get.dart';
import 'home_page_controller.dart';
import 'editor_controller.dart'
;
class Bind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageController());
    Get.lazyPut(() => EditorController(),fenix: true);
    Get.lazyPut(() => NoteSelectPageController());
    Get.lazyPut(() => NotebookController(),fenix: true);
    Get.lazyPut(() => DirectoryEditorController(),fenix: true);
  }
}