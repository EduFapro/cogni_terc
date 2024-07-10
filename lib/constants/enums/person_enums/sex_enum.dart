part of 'person_enums.dart';

enum Sex { male, female, other }

extension SexDesc on Sex {
  String get description {
    switch (this) {
      case Sex.male:
        return "male_sex".tr;
      case Sex.female:
        return "female_sex".tr;
      case Sex.other:
        return "other_sex".tr;
      default:
        return "other_sex".tr;
    }
  }


  int toInt() => this == Sex.male ? 1 : 0;

  static Sex fromInt(int num) => num == 1 ? Sex.male : Sex.female;

  static Sex fromString(String sexString) {
    switch (sexString) {
      case 'male':
        return Sex.male;
      case 'female':
        return Sex.female;
      case 'other':
        return Sex.other;
      default:
        return Sex.other;
    }
  }

}

const Map<Sex, int> _sexValues = {
  Sex.male: 1,
  Sex.female: 2,
};

// Extension to get custom integer value from Sex enum case and vice versa.
extension SexExtension on Sex {
  int get numericValue => _sexValues[this] ?? 0;

  static Sex fromValue(int numericValue) {
    return _sexValues.entries
        .firstWhere((element) => element.value == numericValue,
        orElse: () => MapEntry(Sex.male, 0))
        .key;
  }
}