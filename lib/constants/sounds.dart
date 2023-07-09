import 'package:audioplayers/audioplayers.dart';

class Sounds {
  AudioCache audioCache = AudioCache();
  bool soundLoaded = false;
  Future<void> loadSound() async {
    await audioCache
        .load('sounds/alert-102266.mp3'); // Replace with your audio file path
  }

  void playSound() {
    if (!soundLoaded) {
      loadSound();
    }
    audioCache.play('sounds/alert-102266.mp3');
  }
}
