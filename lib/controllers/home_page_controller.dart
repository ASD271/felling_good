import 'package:felling_good/repository/note_repository.dart';
import 'package:get/get.dart';
import 'package:note_database/note_database.dart';



class HomePageController extends GetxController{
  // NoteRepository noteRepository=NoteRepository();
  @override
  void onInit() async{
    super.onInit();
    // Directory rootDirectory=await noteRepository.getDirectory('directory-root');
    // if(rootDirectory.extensions!=null)
    //   itemNums.value=rootDirectory.extensions!.length;


  }
  late RxList<String> items;
  RxInt itemNums=0.obs;
}