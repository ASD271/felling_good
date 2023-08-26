import 'dart:convert';

import 'package:felling_good/controllers/home_page_controller.dart';
import 'package:felling_good/controllers/note_select/note_select_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_database/note_database.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'notebook_item.dart';

class NoteSelectPage extends StatelessWidget {
  NoteSelectPage({Key? key}) : super(key: key);

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();

  @override
  Widget build(BuildContext context) {
    // String locale;
    // locale = I18n.localeStr;
    // print('now language is $locale');
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(noteSelectPageController.title.value)),
        actions: [
          FloatingActionButton(
            onPressed: noteSelectPageController.addNote,
            child: const Icon(Icons.add),
            heroTag: 'bt1',
          ),
          FloatingActionButton(
            onPressed: noteSelectPageController.editDirectory,
            child: const Icon(Icons.file_open),
            heroTag: 'bt2',
          ),
          FloatingActionButton(
            onPressed: noteSelectPageController.backDirectory,
            child: const Icon(Icons.arrow_back),
            heroTag: 'bt3',
          ),
          FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text('sort'.tr),
                      children: [
                        SimpleDialogOption(
                          onPressed: () {
                            noteSelectPageController
                                .sortAccordingRule(noteSelectPageController.sortDefault);
                            Navigator.pop(context);
                          },
                          child: Text('default'.tr),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            noteSelectPageController
                                .sortAccordingRule(noteSelectPageController.sortCreateTime);
                            Navigator.pop(context);
                          },
                          child: Text('createTime'.tr),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            noteSelectPageController
                                .sortAccordingRule(noteSelectPageController.sortUpdateTime);
                            Navigator.pop(context);
                          },
                          child: Text('updateTime'.tr),
                        ),
                      ],
                    );
                  });
            },
            child: const Icon(Icons.sort),
            heroTag: 'bt4',
          )
        ],
      ),
      body: WillPopScope(
          onWillPop: () async {
            bool res=await noteSelectPageController.backDirectory();
            return !res;
          },
          child: NoteFrame()),
    );
  }
}

class NoteFrame extends StatelessWidget {
  const NoteFrame({Key? key}) : super(key: key);

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: GetBuilder<NoteSelectPageController>(
            builder: (controller) => ListView.builder(
              itemCount: noteSelectPageController.itemNums.value,
              itemBuilder: (context, index) {
                String uid = noteSelectPageController.uids[index];
                if (uid.startsWith('note'))
                  return NoteItem(uid);
                else if (uid.startsWith('directory')) return DirectoryItem(uid);
                return null;
              },
            ),
          ),
        ),
        SizedBox(
          height: 50,
          width: Get.width,
          child: Container(
            child: NoteBottomBar(),
            color: themeData.cardColor,
            // alignment: Alignment.center,
          ),
        ),
      ],
    );
  }
}

class NoteBottomBar extends StatelessWidget {
  NoteBottomBar();

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();

  ElevatedButton _elevatedButton() {
    return ElevatedButton(onPressed: () {}, child: Icon(Icons.abc));
  }

  final RxBool _dark = Get.isDarkMode.obs;

  @override
  Widget build(BuildContext context) {
    print('first $_dark   ${Get.isDarkMode}  i ${1 + 5}');
    final themeData = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            onPressed: noteSelectPageController.addNote,
            child: Icon(Icons.add, color: Get.iconColor)),
        TextButton(onPressed: () {}, child: Icon(Icons.circle)),
        TextButton(onPressed: () {}, child: Icon(Icons.circle)),
        TextButton(onPressed: () {}, child: Icon(Icons.circle)),
        TextButton(
            onPressed: () {
              var t = themeData.copyWith(brightness: Brightness.light);
              Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
              _dark.value = !_dark.value;
              print(_dark);
            },
            child: Obx(() => _dark.value ? Icon(Icons.sunny) : Icon(Icons.dark_mode))),
        // Container(color: Colors.red,width: 100, height: 30,),
      ],
    );
  }
}

