part of 'person_enums.dart';

enum EducationLevel {
  incompleteElementary,
  completeElementary,
  incompleteHighSchool,
  completeHighSchool,
  incompleteCollege,
  completeCollege,
  postgraduate,
}

extension EducationLevelDesc on EducationLevel {
  String get description {
    switch (this) {
      case EducationLevel.incompleteElementary:
        return "incomplete_elementary".tr;
      case EducationLevel.completeElementary:
        return "complete_elementary".tr;
      case EducationLevel.incompleteHighSchool:
        return "incomplete_high_school".tr;
      case EducationLevel.completeHighSchool:
        return "complete_high_school".tr;
      case EducationLevel.incompleteCollege:
        return "incomplete_college".tr;
      case EducationLevel.completeCollege:
        return "complete_college".tr;
      case EducationLevel.postgraduate:
        return "postgraduate".tr;
      default:
        return "unknown".tr;
    }
  }
}

// Map that associates EducationLevel cases with custom integer values.
const Map<EducationLevel, int> _educationLevelValues = {
  EducationLevel.incompleteElementary: 1,
  EducationLevel.completeElementary: 2,
  EducationLevel.incompleteHighSchool: 3,
  EducationLevel.completeHighSchool: 4,
  EducationLevel.incompleteCollege: 5,
  EducationLevel.completeCollege: 6,
  EducationLevel.postgraduate: 7,
};

// Extension to get custom integer value from EducationLevel enum case and vice versa.
extension EducationLevelExtension on EducationLevel {
  int get numericValue => _educationLevelValues[this] ?? 0;

  static EducationLevel fromValue(int numericValue) {
    return _educationLevelValues.entries
        .firstWhere((element) => element.value == numericValue,
            orElse: () => MapEntry(EducationLevel.completeElementary, 2))
        .key;
  }
}
