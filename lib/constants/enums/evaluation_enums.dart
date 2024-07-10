import 'package:get/get.dart';

enum EvaluationStatus { pending, in_progress, completed }

// Extension for EvaluationStatus
extension EvaluationStatusExtension on EvaluationStatus {
  int get numericValue {
    switch (this) {
      case EvaluationStatus.pending:
        return 1;
      case EvaluationStatus.in_progress:
        return 2;
      case EvaluationStatus.completed:
        return 3;
      default:
        return 0;
    }
  }

  String get description {
    switch (this) {
      case EvaluationStatus.pending:
        return 'pending_evaluation'.tr;
      case EvaluationStatus.in_progress:
        return 'in_progress_evaluation'.tr;
      case EvaluationStatus.completed:
        return 'completed_evaluation'.tr;
      default:
        return 'unknown'.tr;
    }
  }

  static EvaluationStatus fromNumericValue(int value) {
    switch (value) {
      case 1:
        return EvaluationStatus.pending;
      case 2:
        return EvaluationStatus.in_progress;
      case 3:
        return EvaluationStatus.completed;
      default:
        return EvaluationStatus.pending;
    }
  }
}
