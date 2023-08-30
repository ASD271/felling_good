import 'package:felling_good/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:note_database/note_database.dart';

class NoteItem<T extends NoteOperation> extends StatelessWidget {
  const NoteItem(this.uid, {super.key});

  final String uid;

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();
  T get noteController=>GetInstance().find<T>();


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

class DirectoryItem<T extends NoteOperation> extends StatelessWidget {
  const DirectoryItem(this.uid, {super.key});

  final String uid;

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();

  T get dirController=>GetInstance().find<T>();

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
                          var dirInfo=noteSelectPageController.analyseDir(uid);

                          return AlertDialog(
                            title: Text('alert'.tr),
                            content: Text(
                                "Are you sure to delete this directory?,here are @dirNum directories and @noteNum notes"
                                    .trParams({'dirNum':'${dirInfo['dirNum']}',
                                  'noteNum':'${dirInfo['noteNum']}'})),
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
            // PopupMenuItem(child: Text("复制")), // Menu Item
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
