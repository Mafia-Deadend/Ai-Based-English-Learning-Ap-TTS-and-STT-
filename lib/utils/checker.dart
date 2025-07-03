List<Map<String, dynamic>> checkPronunciation(String expected, String spoken) {
  final exp = expected.toLowerCase().split(RegExp(r'\s+'));
  final spk = spoken.toLowerCase().split(RegExp(r'\s+'));
  final result = <Map<String, dynamic>>[];

  for (var i = 0; i < exp.length; i++) {
    final w = exp[i];
    final correct = i < spk.length && spk[i] == w;
    result.add({'word': w, 'correct': correct});
  }
  return result;
}
