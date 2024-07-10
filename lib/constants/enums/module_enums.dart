import 'package:get/get.dart';

enum ModuleStatus { pending, in_progress, completed }

// Combine both extensions into a single one
extension ModuleStatusExtension on ModuleStatus {
  // This method returns the custom integer value for each enum case
  int get numericValue {
    switch (this) {
      case ModuleStatus.pending:
        return 1;
      case ModuleStatus.in_progress:
        return 2;
      case ModuleStatus.completed:
        return 3;
      default:
        return 0;
    }
  }

  // This method returns the internationalized string description
  String get description {
    switch (this) {
      case ModuleStatus.pending:
        return 'pending_module'.tr;
      case ModuleStatus.in_progress:
        return 'in_progress_module'.tr;
      case ModuleStatus.completed:
        return 'completed_module'.tr;
      default:
        return 'unknown'.tr;
    }
  }

  // Static method to create a ModuleStatus from its numeric value
  static ModuleStatus fromNumericValue(int value) {
    switch (value) {
      case 1:
        return ModuleStatus.pending;
      case 2:
        return ModuleStatus.in_progress;
      case 3:
        return ModuleStatus.completed;
      default:
        return ModuleStatus.pending;
    }
  }
}
