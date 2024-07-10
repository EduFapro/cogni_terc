import '../../../constants/enums/person_enums/person_enums.dart';
import 'participant_constants.dart';

class ParticipantEntity {
  final int? participantID;
  final String name;
  final String surname;
  final DateTime birthDate;
  final Sex sex;
  final EducationLevel educationLevel;
  // final Handedness handedness;

  ParticipantEntity({
    this.participantID,
    required this.name,
    required this.surname,
    required this.birthDate,
    required this.sex,
    required this.educationLevel,
    // required this.handedness,
  });

  // Adapt fromMap method
  static ParticipantEntity fromMap(Map<String, dynamic> map) {
    return ParticipantEntity(
      participantID: map[ID_PARTICIPANT],
      name: map[PARTICIPANT_NAME],
      surname: map[PARTICIPANT_SURNAME],
      birthDate: DateTime.parse(map[BIRTH_DATE_PARTICIPANT]),
      sex: SexExtension.fromValue(map[PARTICIPANT_SEX]),
      educationLevel: EducationLevelExtension.fromValue(map[PARTICIPANT_EDUCATION_LEVEL]),
      // handedness: HandednessExtension.fromValue(map[PARTICIPANT_HANDEDNESS]),
    );
  }

  // Adapt toMap method
  Map<String, dynamic> toMap() {
    return {
      ID_PARTICIPANT: participantID,
      PARTICIPANT_NAME: name,
      PARTICIPANT_SURNAME: surname,
      BIRTH_DATE_PARTICIPANT: birthDate.toIso8601String(),
      PARTICIPANT_SEX: sex.numericValue,
      PARTICIPANT_EDUCATION_LEVEL: educationLevel.numericValue,
      // PARTICIPANT_HANDEDNESS: handedness.numericValue,
    };
  }

  @override
  String toString() {
    return 'ParticipantEntity{participantID: $participantID, name: $name, surname: $surname, sex: $sex}';
  }

  get fullName => '$name $surname';



}
