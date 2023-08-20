import 'package:felling_good/controllers/home_page_controller.dart';
import 'package:felling_good/controllers/note_select_page_controller.dart';
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
          )
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: noteSelectPageController.itemNums.value,
          itemBuilder: (context, index) {
            String uid = noteSelectPageController.currentDir.value.children![index];
            if (uid.startsWith('note'))
              return NoteItem(uid);
            else if (uid.startsWith('directory')) return DirectoryItem(uid);
            return null;
          },
        ),
      ),
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
      onLongPress: () {print(n.value.title);},
      child: ListTile(
        leading: Icon(Icons.file_copy_sharp),
        title: TextButton(
          onPressed: () {
            noteSelectPageController.openNote(uid);
          },
          child: Obx(() => Text('${n.value.title}')),
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
    return ListTile(
      leading: Icon(Icons.store_mall_directory),
      title: TextButton(
        onPressed: () {
          noteSelectPageController.openDirectory(uid);
        },
        child: Obx(() => Text('${n.value.title}')),
      ),
    );
  }
}
