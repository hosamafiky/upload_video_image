import 'package:flutter/material.dart';

import '../models/media.dart';
import '../utils/utils.dart';
import 'video_widget.dart';

class MediaListWidget extends StatelessWidget {
  const MediaListWidget(this.mediaList, {super.key});

  final ValueNotifier<List<Media>> mediaList;

  void uploadMedia(BuildContext context) async {
    final files = await pickMultiMedia();
    if (files == null) return;
    List<Media> newMediaList = [];
    for (final file in files) {
      if (file.path.toLowerCase().endsWith('.mp4')) {
        final media = Media.video(file: file);
        if (mediaList.value.where((element) => element.isVideo).length == 3) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('You can only upload 3 videos'),
            ),
          );
          return;
        }

        if (media.hasExceededLimit) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Video duration should not exceed 1 minute'),
            ),
          );
          return;
        }

        newMediaList.add(media);
      } else {
        newMediaList.add(Media.image(file: file));
      }
    }

    mediaList.value = [...mediaList.value, ...newMediaList];
  }

  void removeMedia(int index) {
    final currentMedias = List<Media>.from(mediaList.value);
    final media = currentMedias[index];
    if (media.isVideo) {
      media.videoController!.dispose();
    }

    currentMedias.removeAt(index);
    mediaList.value = currentMedias;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), width: 2),
          bottom: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), width: 2),
        ),
      ),
      child: ValueListenableBuilder<List<Media>>(
        valueListenable: mediaList,
        builder: (context, mediaList, _) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemCount: mediaList.length + 1,
            itemBuilder: (context, index) {
              if (index == mediaList.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: (100 - 40) / 2),
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFBE1823),
                      foregroundColor: Colors.white,
                      iconSize: 20,
                      fixedSize: const Size(24, 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.add),
                    onPressed: () => uploadMedia(context),
                  ),
                );
              }
              final media = mediaList[index];
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: media.isVideo
                        ? VideoWidget(
                            media: media,
                            onLimitExceeded: () {
                              if (!context.mounted) return;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text('Video duration should not exceed 1 minute'),
                                  ),
                                );
                                removeMedia(index);
                              });
                            },
                          )
                        : Image.file(media.file),
                  ),
                  PositionedDirectional(
                    top: -10,
                    start: -10,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.transparent,
                      ),
                      icon: const Icon(Icons.close),
                      onPressed: () => removeMedia(index),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
