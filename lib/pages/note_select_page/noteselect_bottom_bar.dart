import 'package:felling_good/controllers/note_select/note_select_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoteBottomBar extends StatelessWidget {
  NoteBottomBar({super.key});

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();

  final RxBool _dark = Get.isDarkMode.obs;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            onPressed: noteSelectPageController.addNote,
            child: Icon(Icons.add, color: Get.iconColor)),
        TextButton(onPressed: () {
          print(noteSelectPageController.notebookController.preferenceInfo.lastOpenedNote);
        }, child: const Icon(Icons.history)),
        TextButton(onPressed: () {}, child: const Icon(Icons.circle)),
        TextButton(onPressed: () {}, child: const Icon(Icons.circle)),
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