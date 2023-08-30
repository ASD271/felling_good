import 'package:felling_good/pages/note_select_page/notebook_item.dart';
import 'package:flutter/material.dart';
import 'package:felling_good/controllers/controllers.dart';
class NoteHistoryPage extends StatelessWidget {
  NoteHistoryController get noteHistoryController => GetInstance().find<NoteHistoryController>();
  const NoteHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('history record'.tr),actions: [
        FloatingActionButton(
          onPressed: noteHistoryController.back,
          heroTag: 'bt3',
          child: const Icon(Icons.arrow_back),
        ),
      ],),
      body: const NoteFrame<NoteHistoryController>(),
    );
  }
}
