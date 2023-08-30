import 'package:flutter/material.dart';
import 'package:felling_good/controllers/controllers.dart';
class NoteHistoryPage extends StatelessWidget {
  NoteHistoryController get noteHistoryController => GetInstance().find<NoteHistoryController>();
  const NoteHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
