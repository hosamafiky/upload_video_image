import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<List<File>?> pickMultiMedia() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowMultiple: true,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4'],
    withData: true,
  );
  if (result == null) return null;
  final pickedFiles = result.files;
  final files = pickedFiles.map((e) => e.xFile);
  return files.map((e) => File(e.path)).toList();
}
