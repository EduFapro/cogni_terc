import 'package:get/get_utils/src/extensions/internacionalization.dart';

enum Language { portuguese, spanish, english }

extension LanguageDescription on Language {
  // Returns the key for translation instead of the direct string
  String get translationKey {
    switch (this) {
      case Language.portuguese:
        return "portuguese_language".tr;
      case Language.spanish:
        return "spanish_language".tr;
      case Language.english:
        return "english_language".tr;
      default:
        return 'select_language'.tr;
    }
  }
}

// Map that associates enum cases with custom integer values.
const Map<Language, int> _languageValues = {
  Language.portuguese: 1,
  Language.spanish: 2,
  Language.english: 3,
};

// Extension to get custom integer value from enum case.
extension EvaluationStatusExtension on Language {
  int get numericValue => _languageValues[this] ?? 0;

  static Language fromValue(int numericValue) {
    return _languageValues.entries
        .firstWhere((element) => element.value == numericValue,
        orElse: () => MapEntry(Language.portuguese, 1))
        .key;
  }
}