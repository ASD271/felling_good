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
            heroTag: null,
            child: const Icon(Icons.arrow_back),
          )
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: dirController.titleCtr,
          ),
          TextField(
            controller: dirController.descCtr,
            maxLines: 5,
          ),
          FloatingActionButton(
            onPressed: dirController.save,
            heroTag: null,
            child: const Icon(Icons.save),
          )
        ],
      ),
    );
  }
}
