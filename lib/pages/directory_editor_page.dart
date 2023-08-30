import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/directory_editor_controller.dart';

class DirectoryEditorPage extends StatelessWidget {
  DirectoryEditorController get dirController => GetInstance().find<DirectoryEditorController>();

  const DirectoryEditorPage(this.parentUid,{Key? key}) : super(key: key);
  final String parentUid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FloatingActionButton(
            onPressed: dirController.back,
            heroTag: null,
            child: const Icon(Icons.arrow_back),
          )
        ],
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (text) {
              dirController.setTitle(text);
            },
          ),
          TextField(
            onChanged: (text) {
              dirController.setDescription(text);
            },
            maxLines: 5,
          ),
          FloatingActionButton(
            onPressed: ()=>dirController.save(parentUid),
            heroTag: null,
            child: const Icon(Icons.save),
          )
        ],
      ),
    );
  }
}
