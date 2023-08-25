import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill_extensions/embeds/embed_types.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

// bool isDesktop() => !kIsWeb && !Platform.isAndroid && !Platform.isIOS;

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
Future<String> onImagePickCallback(File file) async {
  // Copies the picked file from temporary cache to applications directory
  final appDocDir = await getApplicationDocumentsDirectory();
  final copiedFile = await file.copy('${appDocDir.path}/${basename(file.path)}');
  return copiedFile.path.toString();
}

Future<String?> webImagePickImpl(OnImagePickCallback onImagePickCallback) async {
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
Future<String> onVideoPickCallback(File file) async {
  // Copies the picked file from temporary cache to applications directory
  final appDocDir = await getApplicationDocumentsDirectory();
  final copiedFile = await file.copy('${appDocDir.path}/${basename(file.path)}');
  return copiedFile.path.toString();
}

// ignore: unused_element
Future<MediaPickSetting?> selectMediaPickSetting(BuildContext context) =>
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
Future<MediaPickSetting?> selectCameraPickSetting(BuildContext context) =>
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

Future<String> onImagePaste(Uint8List imageBytes) async {
  // Saves the image to applications directory
  final appDocDir = await getApplicationDocumentsDirectory();
  final file =
  await File('${appDocDir.path}/${basename('${DateTime.now().millisecondsSinceEpoch}.png')}')
      .writeAsBytes(imageBytes, flush: true);
  return file.path.toString();
}
