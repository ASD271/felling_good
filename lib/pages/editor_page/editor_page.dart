import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:felling_good/pages/editor_page/EditorBar.dart';
import 'package:felling_good/pages/editor_page/main_editor.dart';
import 'package:felling_good/pages/editor_page/side_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../controllers/editor_page_controller/editor_controller.dart';

class EditorPage extends StatelessWidget {
  EditorController get editorController => GetInstance().find<EditorController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditorController>(builder: (controller) {
      if (editorController.inited.value) {
        final _controller = editorController.controller;
        // if (_controller == null) {
        //   return const Scaffold(body: Center(child: Text('Loading...')));
        // }
        print("obx and $_controller");

        return Scaffold(
          appBar: EditorBar(),
          drawer: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
            color: Colors.grey.shade800,
            child: const SideMenu(),
          ),
          onDrawerChanged: (bool opened) {
            if (opened) editorController.headerNavigationComponent.updateHeader();
          },
          body: Padding(padding:EdgeInsets.all(20),child: const MainEditor()),
        );
      } else {
        return CircularProgressIndicator();
      }
    });
  }

  Future<String?> openFileSystemPickerForDesktop(BuildContext context) async {
    return await FilesystemPicker.open(
      context: context,
      rootDirectory: await getApplicationDocumentsDirectory(),
      fsType: FilesystemType.file,
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );
  }

  // ignore: unused_element
  Future<MediaPickSetting?> _selectMediaPickSetting(BuildContext context) =>
      showDialog<MediaPickSetting>(
        context: context,
        builder: (ctx) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.collections),
                label: const Text('Gallery'),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Gallery),
              ),
              TextButton.icon(
                icon: const Icon(Icons.link),
                label: const Text('Link'),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Link),
              )
            ],
          ),
        ),
      );

  // ignore: unused_element
  Future<MediaPickSetting?> _selectCameraPickSetting(BuildContext context) =>
      showDialog<MediaPickSetting>(
        context: context,
        builder: (ctx) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.camera),
                label: const Text('Capture a photo'),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Camera),
              ),
              TextButton.icon(
                icon: const Icon(Icons.video_call),
                label: const Text('Capture a video'),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Video),
              )
            ],
          ),
        ),
      );
}

