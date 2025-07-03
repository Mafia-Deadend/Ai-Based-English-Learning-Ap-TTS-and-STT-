import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();
  Function(int wordIndex)? onWord;

  TTSService() {
    _tts.setStartHandler(() => print("🔊 TTS started"));

    _tts.setProgressHandler((String text, int start, int end, String word) {
      if (onWord != null) {
        final wordIndex = _getWordIndex(text, start);
        onWord!(wordIndex);
      }
    });

    _tts.setCompletionHandler(() => print("✅ TTS completed"));
    _tts.setCancelHandler(() => print("⏹️ TTS cancelled"));
  }

  int _getWordIndex(String text, int charIndex) {
    final sub = text.substring(0, charIndex);
    return sub.trim().split(RegExp(r'\s+')).length - 1;
  }

  Future<void> speak(String text) async {
    await _tts.setLanguage("en-US");
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.5);
    await _tts.speak(text);
  }

  Future<void> pause() async {
    await _tts.pause();
  }

  Future<void> resume() async {
    // NOTE: Resume may not work on all platforms
    await _tts.awaitSpeakCompletion(true);
    // There’s no built-in continue/resume method in FlutterTTS as of now
    print("▶️ Resume called (no native support on some platforms)");
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
