class TranslationService {
  static final Map<String, String> _dictionary = {
    "boy": "لڑکا",
    "book": "کتاب",
    "read": "پڑھنا",
    "dream": "خواب",
    "writer": "مصنف",
    "love": "محبت کرنا",
    "listen": "سننا",
    // Add more as needed
  };

  String translate(String word) {
    return _dictionary[word.toLowerCase()] ?? "No translation found.";
  }
}
