part of 'note_select_page_controller.dart';
extension NoteSortRules on NoteSelectPageController{
  int sortDefault(String a,String b){
    return a.compareTo(b);
  }
  int sortUpdateTime(String a,String b){
    var n1=notebookController.notebookItems[a].value;
    var n2=notebookController.notebookItems[b].value;
    return n2.itemAttribute.modifyTime-n1.itemAttribute.modifyTime;
  }

  int sortCreateTime(String a,String b){
    var n1=notebookController.notebookItems[a].value;
    var n2=notebookController.notebookItems[b].value;
    return n1.itemAttribute.createTime-n2.itemAttribute.createTime;
  }
}
