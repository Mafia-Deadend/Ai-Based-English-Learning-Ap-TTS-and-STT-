import 'package:flutter/material.dart';
import '../services/tts_service.dart';
import '../state/progress_state.dart';



class ListeningScreen extends StatefulWidget {
  const ListeningScreen({super.key});

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  final TTSService _ttsService = TTSService();

  final String fullText = '''
Once upon a time, in a quiet little village, there lived a boy who loved to explore the forest.
Each morning, he would pack his bag and wander into the woods, looking for adventure.
One day, he found a mysterious map that would change his life forever.
''';

  List<String> words = [];
  int currentWordIndex = -1;
  bool isSpeaking = false;
  bool isPaused = false;

  final List<Map<String, String>> questions = [
    {
      'question': 'Where did the boy live?',
      'answer': 'in a quiet little village',
    },
    {
      'question': 'What did the boy love to explore?',
      'answer': 'the forest',
    },
    {
      'question': 'What did the boy find one day?',
      'answer': 'a mysterious map',
    },
  ];

  late List<TextEditingController> controllers;
  bool submitted = false;

  @override
  void initState() {
    super.initState();
    words = fullText.trim().split(RegExp(r'\s+'));
    controllers = List.generate(questions.length, (_) => TextEditingController());

    _ttsService.onWord = (index) {
      final percent = index / words.length;
      ProgressState().listeningProgress = percent;

      setState(() {
        currentWordIndex = index;
        if (index >= words.length - 1) {
          isSpeaking = false;
          isPaused = false;
        }
      });
    };
  }

  void toggleNarration() async {
    if (isSpeaking) {
      await _ttsService.stop();
      setState(() {
        isSpeaking = false;
        currentWordIndex = -1;
        ProgressState().listeningProgress = 0.0;
      });
    } else {
      setState(() {
        isSpeaking = true;
        isPaused = false;
        currentWordIndex = -1;
      });
      await _ttsService.speak(fullText);
    }
  }

  void pauseOrResume() async {
    if (isPaused) {
      await _ttsService.resume();
    } else {
      await _ttsService.pause();
    }
    setState(() {
      isPaused = !isPaused;
    });
  }

  bool _checkAnswer(int index) {
    final userAnswer = controllers[index].text.trim().toLowerCase();
    final correctAnswer = questions[index]['answer']!.toLowerCase();
    return userAnswer == correctAnswer;
  }

  @override
  void dispose() {
    _ttsService.stop();
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalWords = words.length;
    final progress = currentWordIndex >= 0 ? (currentWordIndex + 1) / totalWords : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔊 Listening & Comprehension'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Narrated Story:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 12),

            // 🧾 Story Words with Highlighting
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 8,
                  children: List.generate(words.length, (index) {
                    final isCurrent = index == currentWordIndex;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCurrent ? Colors.deepPurple : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        words[index],
                        style: TextStyle(
                          fontSize: 16,
                          color: isCurrent ? Colors.white : Colors.black,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 16),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            Text('${(progress * 100).toStringAsFixed(0)}% complete'),
            const SizedBox(height: 12),

            // 🎛️ Control Buttons
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: toggleNarration,
                  icon: Icon(isSpeaking ? Icons.stop : Icons.play_arrow),
                  label: Text(isSpeaking ? 'Stop' : 'Play'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple,foregroundColor: Colors.white),
                ),
                ElevatedButton.icon(
                  onPressed: isSpeaking ? pauseOrResume : null,
                  icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                  label: Text(isPaused ? 'Resume' : 'Pause'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade200,foregroundColor: Colors.deepPurple.shade900,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              '📝 Comprehension Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 8),

            // 🧠 Q&A
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final correct = _checkAnswer(index);
                  // ignore: unused_local_variable
                  final answered = submitted;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Q${index + 1}: ${question['question']}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: controllers[index],
                          enabled: !submitted,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Type your answer...',
                            suffixIcon: submitted
                                ? Icon(
                                    correct ? Icons.check_circle : Icons.cancel,
                                    color: correct ? Colors.green : Colors.red,
                                  )
                                : null,
                          ),
                        ),
                        if (submitted && !correct)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Answer: ${question['answer']}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            ElevatedButton.icon(
              onPressed: () => setState(() => submitted = true),
              icon: const Icon(Icons.check),
              label: const Text('Submit Answers'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
