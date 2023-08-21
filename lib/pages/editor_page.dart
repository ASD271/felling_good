import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

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

import '../controllers/editor_controller.dart';
import '../universal_ui/universal_ui.dart';
import '../widgets/time_stamp_embed_widget.dart';
import 'read_only_page.dart';

class EditorPage extends StatelessWidget {
  EditorController get editorController => GetInstance().find<EditorController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditorController>(builder: (controller){
      if (editorController.inited.value) {
        final _controller = editorController.controller;
        // if (_controller == null) {
        //   return const Scaffold(body: Center(child: Text('Loading...')));
        // }
        print("obx and $_controller");

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey.shade800,
            elevation: 0,
            centerTitle: false,
            title: const Text(
              'Flutter Quill',
            ),
            actions: [
              IconButton(
                onPressed: () => _insertTimeStamp(
                  _controller,
                  DateTime.now().toString(),
                ),
                icon: const Icon(Icons.add_alarm_rounded),
              ),
              IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(_controller.document.toPlainText(
                        [...FlutterQuillEmbeds.builders(), TimeStampEmbedBuilderWidget()])),
                  ),
                ),
                icon: const Icon(Icons.text_fields_rounded),
              ),
              IconButton(onPressed: () => editorController.back(), icon: const Icon(Icons.arrow_back)),
              IconButton(onPressed: ()=>editorController.searchComponent.findText(), icon: Icon(Icons.search))
            ],
          ),
          drawer: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            color: Colors.grey.shade800,
            child: _buildMenuBar(context),
          ),
          body: _buildWelcomeEditor(context),
        );
      } else {
        return CircularProgressIndicator();
      }
    });
  }

  Widget _buildWelcomeEditor(BuildContext context) {
    Widget quillEditor = QuillEditor(
      controller: editorController.controller,
      scrollController: ScrollController(),
      scrollable: true,
      focusNode: editorController.focusNode,
      autoFocus: false,
      readOnly: false,
      placeholder: 'Add content',
      enableSelectionToolbar: isMobile(),
      expands: false,
      padding: EdgeInsets.zero,
      onImagePaste: _onImagePaste,
      onTapUp: (details, p1) {
        return editorController.editorActions.onTripleClickSelection();
      },
      customStyles: DefaultStyles(
        h1: DefaultTextBlockStyle(
            const TextStyle(
              fontSize: 32,
              color: Colors.black,
              height: 1.15,
              fontWeight: FontWeight.w300,
            ),
            const VerticalSpacing(16, 0),
            const VerticalSpacing(0, 0),
            null),
        sizeSmall: const TextStyle(fontSize: 9),
        subscript: const TextStyle(
          fontFamily: 'SF-UI-Display',
          fontFeatures: [FontFeature.subscripts()],
        ),
        superscript: const TextStyle(
          fontFamily: 'SF-UI-Display',
          fontFeatures: [FontFeature.superscripts()],
        ),
      ),
      embedBuilders: [...FlutterQuillEmbeds.builders(), TimeStampEmbedBuilderWidget()],
    );
    if (kIsWeb) {
      quillEditor = QuillEditor(
          controller: editorController.controller,
          scrollController: ScrollController(),
          scrollable: true,
          focusNode: editorController.focusNode,
          autoFocus: false,
          readOnly: false,
          placeholder: 'Add content',
          expands: false,
          padding: EdgeInsets.zero,
          onTapUp: (details, p1) {
            return editorController.editorActions.onTripleClickSelection();
          },
          customStyles: DefaultStyles(
            h1: DefaultTextBlockStyle(
                const TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  height: 1.15,
                  fontWeight: FontWeight.w300,
                ),
                const VerticalSpacing(16, 0),
                const VerticalSpacing(0, 0),
                null),
            sizeSmall: const TextStyle(fontSize: 9),
          ),
          embedBuilders: [...defaultEmbedBuildersWeb, TimeStampEmbedBuilderWidget()]);
    }
    var toolbar = QuillToolbar.basic(
      controller: editorController.controller!,
      embedButtons: FlutterQuillEmbeds.buttons(
        // provide a callback to enable picking images from device.
        // if omit, "image" button only allows adding images from url.
        // same goes for videos.
        onImagePickCallback: _onImagePickCallback,
        onVideoPickCallback: _onVideoPickCallback,
        // uncomment to provide a custom "pick from" dialog.
        // mediaPickSettingSelector: _selectMediaPickSetting,
        // uncomment to provide a custom "pick from" dialog.
        // cameraPickSettingSelector: _selectCameraPickSetting,
      ),
      showAlignmentButtons: true,
      afterButtonPressed: editorController.focusNode.requestFocus,
    );
    if (kIsWeb) {
      toolbar = QuillToolbar.basic(
        controller: editorController.controller!,
        embedButtons: FlutterQuillEmbeds.buttons(
          onImagePickCallback: _onImagePickCallback,
          webImagePickImpl: _webImagePickImpl,
        ),
        showAlignmentButtons: true,
        afterButtonPressed: editorController.focusNode.requestFocus,
      );
    }
    if (_isDesktop()) {
      toolbar = QuillToolbar.basic(
        controller: editorController.controller!,
        embedButtons: FlutterQuillEmbeds.buttons(
          onImagePickCallback: _onImagePickCallback,
          filePickImpl: openFileSystemPickerForDesktop,
        ),
        showAlignmentButtons: true,
        afterButtonPressed: editorController.focusNode.requestFocus,
      );
    }

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextField(
            controller: TextEditingController(text: editorController.note.title),
            onChanged: (text) => editorController.setTitle(text),
          ),
          Expanded(
            flex: 15,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: quillEditor,
            ),
          ),
          kIsWeb
              ? Expanded(
                  child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: toolbar,
                ))
              : Container(child: toolbar)
        ],
      ),
    );
  }

  bool _isDesktop() => !kIsWeb && !Platform.isAndroid && !Platform.isIOS;

  Future<String?> openFileSystemPickerForDesktop(BuildContext context) async {
    return await FilesystemPicker.open(
      context: context,
      rootDirectory: await getApplicationDocumentsDirectory(),
      fsType: FilesystemType.file,
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );
  }

  // Renders the image picked by imagePicker from local file storage
  // You can also upload the picked image to any server (eg : AWS s3
  // or Firebase) and then return the uploaded image URL.
  Future<String> _onImagePickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile = await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
  }

  Future<String?> _webImagePickImpl(OnImagePickCallback onImagePickCallback) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return null;
    }

    // Take first, because we don't allow picking multiple files.
    final fileName = result.files.first.name;
    final file = File(fileName);

    return onImagePickCallback(file);
  }

  // Renders the video picked by imagePicker from local file storage
  // You can also upload the picked video to any server (eg : AWS s3
  // or Firebase) and then return the uploaded video URL.
  Future<String> _onVideoPickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile = await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
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

  Widget _buildMenuBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const itemStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Divider(
          thickness: 2,
          color: Colors.white,
          indent: size.width * 0.1,
          endIndent: size.width * 0.1,
        ),
        ListTile(
          title: const Center(child: Text('Read only demo', style: itemStyle)),
          dense: true,
          visualDensity: VisualDensity.compact,
          onTap: _readOnly,
        ),
        Divider(
          thickness: 2,
          color: Colors.white,
          indent: size.width * 0.1,
          endIndent: size.width * 0.1,
        ),
      ],
    );
  }

  void _readOnly() {
    // Navigator.pop(super.context);
    // Navigator.push(
    //   super.context,
    //   MaterialPageRoute(
    //     builder: (context) => ReadOnlyPage(),
    //   ),
    // );
    print("not ready to navigate");
  }

  Future<String> _onImagePaste(Uint8List imageBytes) async {
    // Saves the image to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final file =
        await File('${appDocDir.path}/${basename('${DateTime.now().millisecondsSinceEpoch}.png')}')
            .writeAsBytes(imageBytes, flush: true);
    return file.path.toString();
  }

  static void _insertTimeStamp(QuillController controller, String string) {
    controller.document.insert(controller.selection.extentOffset, '\n');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );

    controller.document.insert(
      controller.selection.extentOffset,
      TimeStampEmbed(string),
    );

    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );

    controller.document.insert(controller.selection.extentOffset, ' ');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );

    controller.document.insert(controller.selection.extentOffset, '\n');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );
  }
}
