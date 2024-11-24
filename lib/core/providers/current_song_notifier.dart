import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:client/features/home/models/song_model.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? audioPlayer;
  bool isPlaying = false;

  @override
  SongModel? build() {
    return null;
  }

  Future<void> setCurrentSong(SongModel song) async {
    audioPlayer = AudioPlayer();
    // await audioPlayer!.setUrl(song.songUrl);
    final audioSource = AudioSource.uri(Uri.parse(song.songUrl));

    await audioPlayer!.setAudioSource(audioSource);
    audioPlayer!.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
        isPlaying = false;
        state = state?.copyWith(hexCode: state?.hexCode);
      }
    });
    audioPlayer!.play();
    isPlaying = true;
    state = song;
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
    isPlaying = !isPlaying;
    state = state?.copyWith(hexCode: state?.hexCode);
  }
}
