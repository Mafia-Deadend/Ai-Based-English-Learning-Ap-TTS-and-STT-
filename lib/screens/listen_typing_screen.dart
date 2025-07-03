import 'package:flutter/material.dart';
import '../services/tts_service.dart';

class ListenTypingScreen extends StatefulWidget {
  const ListenTypingScreen({super.key});

  @override
  State<ListenTypingScreen> createState() => _ListenTypingScreenState();
}

class _ListenTypingScreenState extends State<ListenTypingScreen> {
  final TTSService _ttsService = TTSService();
  final List<String> questions = [
    'The sun rises in the east.',
    'She went to the market to buy apples.',
    'Learning English can be fun and easy.',
  ];

  int currentIndex = 0;
  String userInput = '';
  String resultMessage = '';
  bool showResult = false;

  void speakCurrent() {
    _ttsService.speak(questions[currentIndex]);
    setState(() {
      showResult = false;
      resultMessage = '';
      userInput = '';
    });
  }

  void checkAnswer() {
    final original = questions[currentIndex].trim().toLowerCase();
    final typed = userInput.trim().toLowerCase();

    setState(() {
      showResult = true;
      resultMessage = original == typed
          ? '✅ Correct!'
          : '❌ Incorrect.\n\nExpected: "$original"\nYour Answer: "$typed"';
    });
  }

  void nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        userInput = '';
        resultMessage = '';
        showResult = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('🎉 Quiz Completed'),
          content: const Text('You have completed all questions! Great job!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  currentIndex = 0;
                  userInput = '';
                  resultMessage = '';
                  showResult = false;
                });
              },
              child: const Text('🔁 Restart'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('✅ Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionNo = currentIndex + 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Listen & Type'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question $questionNo of ${questions.length}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 248, 250, 250),
                
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: speakCurrent,
              icon: const Icon(Icons.volume_up),
              label: const Text('🔊 Listen Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Type what you heard:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            TextField(
              minLines: 2,
              maxLines: 4,
              onChanged: (val) => userInput = val,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write the sentence you heard...',
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: checkAnswer,
              icon: const Icon(Icons.check),
              label: const Text('Submit Answer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),

            if (showResult) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: resultMessage.startsWith('✅') ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  resultMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: resultMessage.startsWith('✅') ? Colors.green[800] : Colors.red[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: nextQuestion,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next Question'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
