import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/directory_editor_controller.dart';

class DirectoryEditorPage extends StatelessWidget {
  DirectoryEditorController get dirController => GetInstance().find<DirectoryEditorController>();

  const DirectoryEditorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FloatingActionButton(
            onPressed: dirController.back,
            child: Icon(Icons.arrow_back),
            heroTag: null,
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
            onPressed: dirController.save,
            child: Icon(Icons.save),
            heroTag: null,
          )
        ],
      ),
    );
  }
}
