import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<List<File>?> pickMultiMedia() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.media,
    allowMultiple: true,
    withData: true,
  );
  if (result == null) return null;
  final xFiles = result.files.map((e) => e.xFile);
  return xFiles.map((e) => File(e.path)).toList();
}
