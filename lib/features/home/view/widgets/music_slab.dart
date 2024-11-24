import 'package:client/core/core.dart';
import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);

    if (currentSong == null) {
      return const SizedBox();
    }

    return Stack(
      children: [
        Container(
          height: 66,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: hexToColor(currentSong.hexCode),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(currentSong.thumbnail),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentSong.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        currentSong.artist,
                        style: const TextStyle(
                          color: Pallete.subtitleText,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.heart,
                      color: Pallete.whiteColor,
                    ),
                  ),
                  IconButton(
                    onPressed: songNotifier.playPause,
                    icon: Icon(
                      songNotifier.isPlaying
                          ? CupertinoIcons.pause_fill
                          : CupertinoIcons.play_fill,
                      color: Pallete.whiteColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        StreamBuilder<Duration>(
          stream: songNotifier.audioPlayer?.positionStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            }

            final duration = snapshot.data;
            final totalDuration = songNotifier.audioPlayer?.duration;

            var percentage = 0.0;

            if (duration != null && totalDuration != null) {
              percentage =
                  duration.inMilliseconds / totalDuration.inMilliseconds;
              return Positioned(
                bottom: 0,
                left: 8,
                child: Container(
                  height: 2,
                  width: percentage * (MediaQuery.of(context).size.width - 16),
                  decoration: BoxDecoration(
                    color: Pallete.whiteColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
        Positioned(
          bottom: 0,
          left: 8,
          child: Container(
            height: 2,
            width: MediaQuery.of(context).size.width - 16,
            decoration: BoxDecoration(
              color: Pallete.inactiveSeekColor,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
      ],
    );
  }
}
