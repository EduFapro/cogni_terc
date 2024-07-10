// part of 'person_enums.dart';
//
// enum Handedness { leftHanded, rightHanded, ambidextrous }
//
// extension HandednessDescription on Handedness {
//   String get description {
//     switch (this) {
//       case Handedness.leftHanded:
//         return "left_handed".tr;
//       case Handedness.rightHanded:
//         return "right_handed".tr;
//       case Handedness.ambidextrous:
//         return "ambidextrous".tr;
//       default:
//         return "unknown".tr;
//     }
//   }
// }
//
// // Map that associates Handedness cases with custom integer values.
// const Map<Handedness, int> _handednessValues = {
//   Handedness.leftHanded: 1,
//   Handedness.rightHanded: 2,
//   Handedness.ambidextrous: 3,
// }; // Extension to get custom integer value from Handedness enum case and vice versa.
//
// extension HandednessExtension on Handedness {
//   int get numericValue => _handednessValues[this] ?? 0;
//
//   static Handedness fromValue(int numericValue) {
//     return _handednessValues.entries
//         .firstWhere((element) => element.value == numericValue,
//             orElse: () => MapEntry(Handedness.ambidextrous, 0))
//         .key;
//   }
// }
