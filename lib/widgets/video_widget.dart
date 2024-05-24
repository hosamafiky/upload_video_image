import 'package:flutter/material.dart';
import 'package:upload_video_image/extensions/format_duration.dart';
import 'package:video_player/video_player.dart';

import '../models/media.dart';

class VideoWidget extends StatelessWidget {
  const VideoWidget({
    super.key,
    required this.media,
    required this.onLimitExceeded,
  });

  final Media media;
  final VoidCallback onLimitExceeded;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: media.videoController!,
      builder: (context, value, child) {
        if (value.duration.inSeconds > 60) {
          onLimitExceeded.call();
        }
        return Stack(
          children: [
            AspectRatio(
              aspectRatio: value.aspectRatio,
              child: VideoPlayer(media.videoController!),
            ),
            Center(
              child: IconButton(
                icon: Icon(value.isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  if (value.isPlaying) {
                    media.videoController!.pause();
                  } else {
                    media.videoController!.play();
                  }
                },
              ),
            ),
            PositionedDirectional(
              bottom: 0,
              end: 0,
              child: Text(
                value.duration.format,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
