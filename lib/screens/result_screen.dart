import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final List<Map<String, dynamic>> feedback;
  const ResultScreen({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    final correct = feedback.where((w) => w['correct'] == true).length;
    final total = feedback.length;
    final accuracy = total > 0 ? correct / total : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Pronunciation Result'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Your Accuracy',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              '${(accuracy * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: accuracy >= 0.7 ? Colors.green : Colors.redAccent,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: accuracy,
              color: Colors.indigo,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 30),
            const Text(
              'Word Feedback',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // ✅ Colored chips for each word
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: feedback.map((w) {
                    final bool correct = w['correct'] == true;
                    return Chip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            correct ? Icons.check : Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(w['word']),
                        ],
                      ),
                      backgroundColor: correct ? Colors.green : Colors.redAccent,
                      labelStyle: const TextStyle(color: Colors.white),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              onPressed: () => Navigator.pop(context),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
