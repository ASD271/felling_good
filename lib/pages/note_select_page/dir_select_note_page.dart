import 'package:felling_good/controllers/controllers.dart';
import 'package:felling_good/controllers/note_select/note_select_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notebook_item.dart';
import 'noteselect_bottom_bar.dart';

class NoteSelectPage extends StatelessWidget {
  const NoteSelectPage({Key? key}) : super(key: key);

  NoteSelectPageController get noteSelectPageController =>
      GetInstance().find<NoteSelectPageController>();
  DirSelectPageController get dirSelectPageController => GetInstance().find<DirSelectPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(dirSelectPageController.title.value)),
        actions: [
          FloatingActionButton(
            onPressed: noteSelectPageController.continueLastOpenedNote,
            heroTag: 'bt1',
            child: const Icon(Icons.keyboard_arrow_right),
          ),

          FloatingActionButton(
            onPressed: dirSelectPageController.backDirectory,
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
                            dirSelectPageController
                                .sortAccordingRule(noteSelectPageController.sortDefault);
                            Navigator.pop(context);
                          },
                          child: Text('default'.tr),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            dirSelectPageController
                                .sortAccordingRule(noteSelectPageController.sortCreateTime);
                            Navigator.pop(context);
                          },
                          child: Text('createTime'.tr),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            dirSelectPageController
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
            bool res = await dirSelectPageController.backDirectory();
            return !res;
          },
          child: const NoteFrame()),
    );
  }
}

class NoteFrame extends StatelessWidget {
  const NoteFrame({Key? key}) : super(key: key);

  // NoteSelectPageController get noteSelectPageController =>
  //     GetInstance().find<NoteSelectPageController>();
  DirSelectPageController get dirSelectPageController => GetInstance().find<DirSelectPageController>();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: GetBuilder<DirSelectPageController>(
            builder: (controller) => ListView.builder(
              itemCount: dirSelectPageController.itemNums.value,
              itemBuilder: (context, index) {
                String uid = dirSelectPageController.uids[index];
                if (uid.startsWith('note')) {
                  return NoteItem<DirSelectPageController>(uid);
                } else if (uid.startsWith('directory')) {
                  return DirectoryItem<DirSelectPageController>(uid);
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

