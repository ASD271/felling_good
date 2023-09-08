import 'package:felling_good/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoteBottomBar extends StatelessWidget {
  NoteBottomBar({super.key});

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();
  DirSelectPageController get dirSelectPageController => GetInstance().find<DirSelectPageController>();
  final RxBool _dark = Get.isDarkMode.obs;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            onPressed: dirSelectPageController.addNote,
            child: Icon(Icons.add, color: Get.iconColor)),
        TextButton(
          onPressed: dirSelectPageController.editDirectory,
          child: Icon(Icons.file_open,color: Get.iconColor),
        ),
        TextButton(onPressed: ()async {
          print(noteSelectPageController.notebookController.preferenceInfo.lastOpenedNote);
          await noteSelectPageController.openHistoryPage();
          dirSelectPageController.updateDirectory();

        }, child: Icon(Icons.history,color: Get.iconColor)),

        TextButton(onPressed: () async {
            var keys=await noteSelectPageController.notebookController.noteRepository.getOpinionKeys();
            print(keys);
        }, child: const Icon(Icons.circle)),
        TextButton(
            onPressed: () {
              Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
              _dark.value = !_dark.value;
            },
            child: Obx(() => _dark.value ? const Icon(Icons.sunny) : const Icon(Icons.dark_mode))),
        // Container(color: Colors.red,width: 100, height: 30,),
      ],
    );
  }
}