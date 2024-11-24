import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  final String path;
  const AudioWave({super.key, required this.path});

  @override
  _AudioWaveState createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final playerController = PlayerController();

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  Future<void> initAudioPlayer() async {
    await playerController.preparePlayer(path: widget.path);

    playerController.onCompletion.listen((event) async {
      await playerController.seekTo(0);
      await playerController.stopPlayer();
      await playerController.preparePlayer(path: widget.path);
      setState(() {});
    });
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  Future<void> playAndPause() async {
    if (playerController.playerState.isPlaying) {
      await playerController.pausePlayer();
    } else if (!playerController.playerState.isPlaying) {
      await playerController.startPlayer();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: playAndPause,
          icon: Icon(
            playerController.playerState.isPlaying
                ? CupertinoIcons.pause_solid
                : CupertinoIcons.play_arrow_solid,
          ),
        ),
        Expanded(
          child: AudioFileWaveforms(
            size: const Size(double.infinity, 100),
            playerController: playerController,
            playerWaveStyle: const PlayerWaveStyle(
              fixedWaveColor: Pallete.borderColor,
              liveWaveColor: Pallete.gradient1,
              spacing: 6,
              // showSeekLine: false,
            ),
            // waveformType: WaveformType.fitWidth,
          ),
        ),
      ],
    );
  }
}
