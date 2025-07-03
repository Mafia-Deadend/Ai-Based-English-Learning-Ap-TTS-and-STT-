import 'package:flutter/material.dart';
import 'story_screen.dart';
import 'listening_screen.dart';
import 'listen_typing_screen.dart';
import '../state/progress_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final progress = ProgressState();

  @override
  Widget build(BuildContext context) {
    final quizProgress = progress.quizTotal > 0
        ? '${progress.quizCorrect}/${progress.quizTotal}'
        : 'Not started';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('English learner AI'),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Progress',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset Progress?'),
                  content: const Text('Are you sure you want to reset all progress?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              );
              if (confirm ?? false) {
                setState(() {
                  progress.resetAll();
                });
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Text(
              'Welcome to English Learning 🎓',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Reading Practice
            _buildModeCard(
              icon: Icons.menu_book,
              title: 'Reading Practice',
              color: Colors.orange,
              subtitle: 'Accuracy: ${(progress.readingAccuracy * 100).toStringAsFixed(0)}%',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StoryScreen()),
                ).then((_) => setState(() {}));
              },
            ),

            // Listening Mode
            _buildModeCard(
              icon: Icons.headphones,
              title: 'Listening Mode',
              color: Colors.teal,
              subtitle: 'Progress: ${(progress.listeningProgress * 100).toStringAsFixed(0)}%',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ListeningScreen()),
                ).then((_) => setState(() {}));
              },
            ),

            // Listen & Type
            _buildModeCard(
              icon: Icons.edit_note,
              title: 'Listen & Type Quiz',
              color: Colors.purple,
              subtitle: 'Score: $quizProgress',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ListenTypingScreen()),
                ).then((_) => setState(() {}));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
