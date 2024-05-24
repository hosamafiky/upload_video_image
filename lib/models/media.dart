import 'dart:io';

import 'package:video_player/video_player.dart';

class Media {
  final File file;

  Media.image({
    required this.file,
  }) : videoController = null;

  Media.video({
    required this.file,
  }) : videoController = VideoPlayerController.file(file)
          ..initialize()
          ..setVolume(0);

  bool get isVideo => file.path.toLowerCase().endsWith('.mp4');
  bool get hasExceededLimit => videoController!.value.duration.inSeconds > 60;
  final VideoPlayerController? videoController;
}
