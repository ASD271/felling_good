import 'package:felling_good/pages/editor_page/hightlight_button.dart';
import 'package:felling_good/widgets/opinion_embed_widget.dart';
import 'package:flutter/material.dart';
import 'package:felling_good/controllers/controllers.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';


import 'package:felling_good/controllers/utils/utils.dart';


class MainEditor extends StatelessWidget {
  EditorController get editorController => GetInstance().find<EditorController>();
  QuillGetController get quillGetController => GetInstance().find<QuillGetController>();

  const MainEditor({Key? key}) : super(key: key);

  QuillEditor getQuillEditor() {
    if (kIsWeb) {
      return QuillEditor(
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
          embedBuilders: [
            // ...defaultEmbedBuildersWeb,
            ...quillGetController.embedBuilders,
          ]);
    }
    return QuillEditor(
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
      onImagePaste: onImagePaste,
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
      embedBuilders: [
        // ...FlutterQuillEmbeds.builders(),
        ...quillGetController.embedBuilders,
      ],
    );
  }

  QuillToolbar getQuillToolBar() {
    List<EmbedButtonBuilder>? embedButtons;
    if (kIsWeb) {
      embedButtons = FlutterQuillEmbeds.buttons(
        onImagePickCallback: onImagePickCallback,
        webImagePickImpl: webImagePickImpl,
      );
      return QuillToolbar.basic(
        controller: editorController.controller,
        embedButtons: embedButtons,
        showAlignmentButtons: true,
        afterButtonPressed: editorController.focusNode.requestFocus,
        locale: Get.locale,
      );
    }
    if (isDesktop()) {
      embedButtons = FlutterQuillEmbeds.buttons(
        onImagePickCallback: onImagePickCallback,
        filePickImpl: openFileSystemPickerForDesktop,
      )..add((controller, toolbarIconSize, iconTheme, dialogTheme) =>
          HighlightButton(controller, afterButtonPressed: editorController.focusNode.requestFocus));
      return QuillToolbar.basic(
        controller: editorController.controller,
        embedButtons: embedButtons,
        showAlignmentButtons: true,
        afterButtonPressed: editorController.focusNode.requestFocus,
        locale: Get.locale,
      );
    }
    embedButtons = FlutterQuillEmbeds.buttons(
      // provide a callback to enable picking images from device.
      // if omit, "image" button only allows adding images from url.
      // same goes for videos.
      onVideoPickCallback: onVideoPickCallback,
      onImagePickCallback: onImagePickCallback,
      // uncomment to provide a custom "pick from" dialog.
      // mediaPickSettingSelector: _selectMediaPickSetting,
      // uncomment to provide a custom "pick from" dialog.
      // cameraPickSettingSelector: _selectCameraPickSetting,
    )..add((controller, toolbarIconSize, iconTheme, dialogTheme) =>
        HighlightButton(controller, afterButtonPressed: editorController.focusNode.requestFocus));
    return QuillToolbar.basic(
      controller: editorController.controller,
      embedButtons: embedButtons,
      showAlignmentButtons: true,
      afterButtonPressed: editorController.focusNode.requestFocus,
      locale: Get.locale,
    );
  }

  @override
  Widget build(BuildContext context) {
    var quillEditor = getQuillEditor();
    var toolbar = getQuillToolBar();

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextField(
            controller: TextEditingController(text: editorController.note.title),
            onChanged: (text) => editorController.setTitle(text),
            onSubmitted: editorController.titleSubmit,
          ),
          Expanded(
            flex: 15,
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: quillEditor,
            ),
          ),
          Obx(() {
            if (editorController.showBottomBar.value) {
              return kIsWeb
                  ? Expanded(
                      child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: toolbar,
                    ))
                  : Container(child: toolbar);
            }
            return Container();
          })
        ],
      ),
    );
  }
}
