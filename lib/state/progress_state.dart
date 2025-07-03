class ProgressState {
  static final ProgressState _instance = ProgressState._internal();

  factory ProgressState() => _instance;
  ProgressState._internal();

  double readingAccuracy = 0.0; // 0.0 to 1.0
  double listeningProgress = 0.0; // 0.0 to 1.0
  int quizCorrect = 0;
  int quizTotal = 0;

  void resetAll() {
    readingAccuracy = 0.0;
    listeningProgress = 0.0;
    quizCorrect = 0;
    quizTotal = 0;
  }
}
