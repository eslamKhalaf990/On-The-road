import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;

Future<String> sttFn(List<String> words) async {
  stt.SpeechToText speech = stt.SpeechToText();
  Completer<String> completer =
      Completer<String>(); // Completer to resolve the future
  bool wordFound = false; // Flag to track if a word is found

  try {
    bool available = await speech.initialize();
    if (!available) {
      print('Speech to text not available');
    }
    print("stt started");
    speech.listen(
      onResult: (result) {
        print(result.recognizedWords);
        if (wordFound) return;
        for (String word in words) {
          if (containsWord(result.recognizedWords, word)) {
            print("word $word found");
            wordFound = true;
            completer.complete(word);
            speech.stop();
            break;
          }
        }
      },
    );
    return completer.future;
  } catch (e) {
    print('Error in speech to text: $e');
    completer.complete(
        '');
    return completer.future; // Return the future
  }
}

bool containsWord(String sentence, String word) {
  List<String> words = sentence.split(' ');
  return words.contains(word);
}
