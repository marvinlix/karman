import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class SoundManager {
  final AudioPlayer backgroundPlayer = AudioPlayer();
  final AudioPlayer chimePlayer = AudioPlayer();

  final List<Map<String, dynamic>> sounds = [
    {'name': 'None', 'icon': CupertinoIcons.nosign, 'file': null},
    {
      'name': 'Rain',
      'icon': CupertinoIcons.cloud_rain,
      'file': 'lib/assets/audio/rain.mp3'
    },
    {
      'name': 'Ocean',
      'icon': CupertinoIcons.drop,
      'file': 'lib/assets/audio/ocean.mp3'
    },
    {
      'name': 'Forest',
      'icon': CupertinoIcons.tree,
      'file': 'lib/assets/audio/forest.mp3'
    },
    {
      'name': 'Airplane',
      'icon': CupertinoIcons.airplane,
      'file': 'lib/assets/audio/airplane.mp3'
    },
  ];

  String? currentSound;

  Future<void> playSelectedSound() async {
    if (currentSound != null) {
      await backgroundPlayer.setAsset(currentSound!);
      await backgroundPlayer.setLoopMode(LoopMode.one);
      backgroundPlayer.play();
    }
  }

  Future<void> stopBackgroundSound() async {
    await backgroundPlayer.stop();
  }

  Future<void> playChime() async {
    try {
      await chimePlayer.setAsset('lib/assets/audio/subtle_chime.mp3');
      await chimePlayer.play();
    } catch (e) {
      print('Error playing chime: $e');
    }
  }

  void dispose() {
    backgroundPlayer.dispose();
    chimePlayer.dispose();
  }
}