export 'note_history_page_controller.dart' show NoteHistoryController;
export 'note_select_page_controller.dart' show NoteSelectPageController;
export 'dir_select_note_controller.dart';

abstract class NoteOperation{
  void openNote(String uid);
  void deleteNote(String uid);
  void openDir(String uid);
  void deleteDir(String uid);
}