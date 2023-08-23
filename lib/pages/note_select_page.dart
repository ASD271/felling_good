import 'dart:convert';

import 'package:felling_good/controllers/home_page_controller.dart';
import 'package:felling_good/controllers/note_select/note_select_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_database/note_database.dart';

class NoteSelectPage extends StatelessWidget {
  NoteSelectPage({Key? key}) : super(key: key);

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();

  @override
  Widget build(BuildContext context) {
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
                      title: Text('sort'),
                      children: [
                        SimpleDialogOption(
                          onPressed: () {
                            noteSelectPageController
                                .sortAccordingRule(noteSelectPageController.sortDefault);
                            Navigator.pop(context);
                          },
                          child: Text('default'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            noteSelectPageController
                                .sortAccordingRule(noteSelectPageController.sortCreateTime);
                            Navigator.pop(context);
                          },
                          child: Text('createTime'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            noteSelectPageController
                                .sortAccordingRule(noteSelectPageController.sortUpdateTime);
                            Navigator.pop(context);
                          },
                          child: Text('updateTime'),
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
      body: NoteFrame(),
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

  ElevatedButton _elevatedButton() {
    return ElevatedButton(onPressed: () {}, child: Icon(Icons.abc));
  }

  final RxBool _dark = Get.isDarkMode.obs;

  @override
  Widget build(BuildContext context) {
    print('first $_dark   ${Get.isDarkMode}  i ${1 + 5}');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            onPressed: () {
              Get.changeTheme(
                Get.isDarkMode ? ThemeData.light() : ThemeData.dark(),
              );
              _dark.value = !_dark.value;
              print(_dark);
            },
            child: Obx(() => _dark.value ? Icon(Icons.sunny) : Icon(Icons.dark_mode))),
        TextButton(onPressed: () {}, child: Icon(Icons.add)),
        TextButton(onPressed: () {}, child: Icon(Icons.add)),
        TextButton(onPressed: () {}, child: Icon(Icons.add)),
        TextButton(onPressed: () {}, child: Icon(Icons.add)),
        // Container(color: Colors.red,width: 100, height: 30,),
      ],
    );
  }
}

class NoteItem extends StatelessWidget {
  NoteItem(this.uid);

  final String uid;

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();

  @override
  Widget build(BuildContext context) {
    var n = noteSelectPageController.getNote(uid);
    return GestureDetector(
      // onLongPress: () {
      //   print(n.value.title);
      // },
      onLongPressStart: (details) {
        Feedback.forLongPress(context); // Add Feedback
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            details.globalPosition.dx,
            details.globalPosition.dy,
          ),
          items: <PopupMenuEntry>[
            PopupMenuItem(
              child: Text("删除"),
              onTap: () {
                noteSelectPageController.deleteNote(uid);
              },
            ), // Menu Item
            // PopupMenuItem(child: Text("复制")), // Menu Item
          ],
        );
      },
      child: TextButton(
        onPressed: () {
          noteSelectPageController.openNote(uid);
        },
        child: Obx(
          () => ListTile(
            leading: Icon(Icons.file_copy_sharp),
            title: Text('${n.value.title}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${noteSelectPageController.decodeNoteDesc(n.value.jsonContent)}',
                    overflow: TextOverflow.ellipsis),
                Text('${noteSelectPageController.getDate(n.value.itemAttribute.createTime)}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DirectoryItem extends StatelessWidget {
  DirectoryItem(this.uid);

  final String uid;

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();

  @override
  Widget build(BuildContext context) {
    Rx<Directory> n = noteSelectPageController.getDir(uid);
    return TextButton(
      onPressed: () {
        noteSelectPageController.openDirectory(uid);
      },
      child: ListTile(
        leading: Icon(Icons.store_mall_directory),
        title: Obx(() => Text('${n.value.title}')),
        // titleAlignment: ListTileTitleAlignment.threeLine,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${n.value.description}', overflow: TextOverflow.ellipsis),
            Text('${noteSelectPageController.getDate(n.value.itemAttribute.createTime)}'),
          ],
        ),
      ),
    );
  }
}
