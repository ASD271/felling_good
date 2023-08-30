import 'package:felling_good/controllers/note_select/note_select_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notebook_item.dart';
import 'noteselect_bottom_bar.dart';

class NoteSelectPage extends StatelessWidget {
  const NoteSelectPage({Key? key}) : super(key: key);

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(noteSelectPageController.title.value)),
        actions: [
          FloatingActionButton(
            onPressed: noteSelectPageController.continueLastOpenedNote,
            heroTag: 'bt1',
            child: const Icon(Icons.keyboard_arrow_right),
          ),
          FloatingActionButton(
            onPressed: noteSelectPageController.editDirectory,
            heroTag: 'bt2',
            child: const Icon(Icons.file_open),
          ),
          FloatingActionButton(
            onPressed: noteSelectPageController.backDirectory,
            heroTag: 'bt3',
            child: const Icon(Icons.arrow_back),
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
            heroTag: 'bt4',
            child: const Icon(Icons.sort),
          )
        ],
      ),
      body: WillPopScope(
          onWillPop: () async {
            bool res = await noteSelectPageController.backDirectory();
            return !res;
          },
          child: const NoteFrame()),
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
                if (uid.startsWith('note')) {
                  return NoteItem(uid);
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

