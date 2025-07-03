import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();

  Future<bool> init() async => await _speech.initialize();

  void startListening(void Function(String) onResult) {
    _speech.listen(onResult: (result) => onResult(result.recognizedWords));
  }

  void stopListening() => _speech.stop();

  bool get isListening => _speech.isListening;
}
