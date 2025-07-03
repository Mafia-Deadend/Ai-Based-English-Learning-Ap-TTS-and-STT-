import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const _key = 'last_sentence_index';

  Future<void> saveIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, index);
  }

  Future<int> loadIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }
}
