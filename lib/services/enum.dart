enum Language { it, en }

extension LanguageEmoji on Language {
  String get emoji {
    switch (this) {
      case Language.it:
        return '🇮🇹';
      case Language.en:
        return '🇬🇧';
    }
  }
}