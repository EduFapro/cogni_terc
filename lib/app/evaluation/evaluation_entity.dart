import 'dart:convert';
import '../../../constants/enums/evaluation_enums.dart';
import 'evaluation_constants.dart';

class EvaluationEntity {
  final int? evaluationID;
  final int evaluatorID;
  final int participantID;
  EvaluationStatus status;
  DateTime evaluationDate;
  final int language;

  EvaluationEntity(
      {this.evaluationID,
      DateTime? evaluationDate,
      this.status = EvaluationStatus.pending,
      required this.evaluatorID,
      required this.participantID,
      required this.language})
      : evaluationDate = evaluationDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      ID_EVALUATION: evaluationID,
      EVALUATION_DATE: evaluationDate.toIso8601String(),
      ID_EVALUATOR_FK: evaluatorID,
      EVALUATION_STATUS: status.numericValue,
      ID_PARTICIPANT_FK: participantID,
      LANGUAGE: language,
    };
  }

  static EvaluationEntity fromMap(Map<String, dynamic> map) {
    int? evaluationID = map[ID_EVALUATION] as int?;
    int evaluatorID = map[ID_EVALUATOR_FK] as int;
    int participantID = map[ID_PARTICIPANT_FK] as int;
    int language = map[LANGUAGE] as int;
    int statusValue = map[EVALUATION_STATUS] ?? 1;
    EvaluationStatus status = EvaluationStatusExtension.fromNumericValue(statusValue);

    DateTime evaluationDate = DateTime.now();

    // Check if the date string is not null before parsing
    if (map[EVALUATION_DATE] != null) {
      String dateString = map[EVALUATION_DATE];
      DateTime? parsedDate = DateTime.tryParse(dateString);
      if (parsedDate != null) {
        evaluationDate = parsedDate;
      } else {
        // Handle the case where the date string is not in a valid format
        print("Error parsing date string: $dateString");
      }
    }

    var newEntity = EvaluationEntity(
      evaluationID: evaluationID,
      evaluatorID: evaluatorID,
      status: status,
      evaluationDate: evaluationDate,
      participantID: participantID,
      language: language,
    );
    return newEntity;
  }

  // Convert EvaluationEntity to JSON string
  String toJson() {
    final Map<String, dynamic> data = this.toMap();
    return jsonEncode(data);
  }

  // Convert JSON string to EvaluationEntity
  static EvaluationEntity fromJson(String jsonString) {
    final data = jsonDecode(jsonString);
    return EvaluationEntity.fromMap(data);
  }

  @override
  String toString() {
    return 'EvaluationEntity(evaluationID: $evaluationID, evaluatorID: $evaluatorID, participantID: $participantID, status: ${status.description})';
  }
}
