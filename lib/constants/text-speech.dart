import 'package:flutter_tts/flutter_tts.dart';

class TextSpeech{

  static speak (String text) async {
    final FlutterTts flutterTts = FlutterTts();
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }
}