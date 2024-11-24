import 'package:client/core/core.dart';
import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(getAllSongsProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Latest Today',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          songs.when(
            data: (songs) => SongsList(
              songs: songs,
            ),
            loading: () => const CircularProgressIndicator(),
            error: (error, st) => Text(error.toString()),
          ),
        ],
      ),
    );
  }
}

class SongsList extends ConsumerWidget {
  final List<SongModel> songs;

  const SongsList({
    super.key,
    required this.songs,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        itemCount: songs.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final song = songs[index];
          return GestureDetector(
            onTap: () {
              ref
                  .read(currentSongNotifierProvider.notifier)
                  .setCurrentSong(song);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(song.thumbnail),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: 180,
                    child: Text(
                      song.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: Text(
                      song.artist,
                      style: const TextStyle(
                        color: Pallete.subtitleText,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
