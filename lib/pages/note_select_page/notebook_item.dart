import 'package:felling_good/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:note_database/note_database.dart';

import 'noteselect_bottom_bar.dart';

class NoteFrame<T extends NoteSelectController> extends StatelessWidget {
  const NoteFrame({Key? key}) : super(key: key);

  // NoteSelectPageController get noteSelectPageController =>
  //     GetInstance().find<NoteSelectPageController>();
  // DirSelectPageController get dirSelectPageController => GetInstance().find<DirSelectPageController>();
  T get frameController => GetInstance().find<T>();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: GetBuilder<T>(
            builder: (controller) => ListView.builder(
              itemCount: frameController.itemNums.value,
              itemBuilder: (context, index) {
                String uid = frameController.uids[index];
                if (uid.startsWith('note')) {
                  return NoteItem<T>(uid);
                } else if (uid.startsWith('directory')) {
                  return DirectoryItem(uid);
                }
                return null;
              },
            ),
          ),
        ),
        SizedBox(
          height: 50,
          width: Get.width,
          child: Container(
            color: themeData.cardColor,
            child: NoteBottomBar(),
            // alignment: Alignment.center,
          ),
        ),
      ],
    );
  }
}

class NoteItem<T extends NoteSelectController> extends StatelessWidget {
  const NoteItem(this.uid, {super.key});

  final String uid;

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();

  T get noteController => GetInstance().find<T>();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    var n = noteSelectPageController.getNote(uid);
    return GestureDetector(
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
              child: Text("delete".tr),
              onTap: () {
                noteController.deleteNote(uid);
              },
            ), // Menu Item
            // PopupMenuItem(child: Text("复制")), // Menu Item
          ],
        );
      },
      onTap: () {
        noteController.openNote(uid);
      },
      child: Obx(
        () => ListTile(
          leading: Icon(Icons.note, color: themeData.cardColor),
          title: Text(n.value.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(noteSelectPageController.decodeNoteDesc(n.value.jsonContent),
                  overflow: TextOverflow.ellipsis),
              Text(noteSelectPageController.getDate(n.value.itemAttribute.createTime)),
            ],
          ),
        ),
      ),
    );
  }
}

class DirectoryItem extends StatelessWidget {
  const DirectoryItem(this.uid, {super.key});

  final String uid;

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();

  DirSelectPageController get dirController => GetInstance().find<DirSelectPageController>();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    Rx<Directory> n = noteSelectPageController.getDir(uid);
    return GestureDetector(
      onTap: () {
        dirController.openDir(uid);
      },
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
              child: Text("delete".tr),
              onTap: () {
                Future.delayed(
                    const Duration(seconds: 0),
                    () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          var dirInfo = noteSelectPageController.analyseDir(uid);

                          return AlertDialog(
                            title: Text('alert'.tr),
                            content: Text(
                                "Are you sure to delete this directory?,here are @dirNum directories and @noteNum notes"
                                    .trParams({
                              'dirNum': '${dirInfo['dirNum']}',
                              'noteNum': '${dirInfo['noteNum']}'
                            })),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('cancel'.tr)),
                              TextButton(
                                child: Text("confirm".tr),
                                onPressed: () {
                                  dirController.deleteDir(uid);
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        }));
              },
            ), // Menu Item
            PopupMenuItem(
                child: Text("change".tr),
                onTap: () {
                  Future.delayed(
                      const Duration(seconds: 0), () => dirController.editDirectory(uid));
                }), // Menu Item
          ],
        );
      },
      child: ListTile(
        leading: Icon(
          Icons.folder,
          color: themeData.cardColor,
        ),
        title: Obx(() => Text(n.value.title)),
        // titleAlignment: ListTileTitleAlignment.threeLine,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(n.value.description, overflow: TextOverflow.ellipsis),
            Text(noteSelectPageController.getDate(n.value.itemAttribute.createTime)),
          ],
        ),
      ),
    );
  }
}
