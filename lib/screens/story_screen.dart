import 'package:flutter/material.dart';
import '../services/speech_service.dart';
import '../services/tts_service.dart';
import '../utils/checker.dart';
import 'result_screen.dart';
import '../state/progress_state.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});
  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final SpeechService _speechService = SpeechService();
  final TTSService _ttsService = TTSService();

  String storyText = '';
  String userSpeech = '';
  List<Map<String, dynamic>> feedback = [];

  @override
  void initState() {
    super.initState();
    _speechService.init();
    loadStory();
  }

  Future<void> loadStory() async {
    final text = await DefaultAssetBundle.of(context)
        .loadString('assets/stories/story_1.txt');
    print('Story loaded: $text');
    setState(() => storyText = text);
  }

  void onSpeechResult(String result) {
    setState(() => userSpeech = result);
  }

  void checkResult() {
    feedback = checkPronunciation(storyText, userSpeech);

    for (var w in feedback) {
      if (!w['correct']) {
        _ttsService.speak(w['word']);
        break;
      }
    }

    final correctCount = feedback.where((f) => f['correct']).length;
    final total = feedback.length;
    ProgressState().readingAccuracy = total > 0 ? correctCount / total : 0.0;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResultScreen(feedback: feedback)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('📖 Reading Practice'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Read the story aloud and check your pronunciation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // 📜 Story Text
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.indigo.shade100),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    storyText,
                    style: const TextStyle(fontSize: 17, height: 1.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🎤 User Speech
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🗣️ You said:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(userSpeech.isNotEmpty ? userSpeech : 'No speech detected yet.'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🎛️ Controls
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: _speechService.isListening
                      ? null
                      : () => _speechService.startListening(onSpeechResult),
                  icon: const Icon(Icons.mic),
                  label: const Text('Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _speechService.isListening
                      ? _speechService.stopListening
                      : null,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: checkResult,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Check'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
