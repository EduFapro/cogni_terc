import 'package:get/get.dart';

enum TaskStatus {
  pending(0, 'pending'),
  done(1, 'done');

  final int numericValue;
  final String descriptionKey;

  const TaskStatus(this.numericValue, this.descriptionKey);

  String get description => descriptionKey.tr;

  static TaskStatus fromNumericValue(int value) {
    return TaskStatus.values.firstWhere(
          (status) => status.numericValue == value,
      orElse: () => TaskStatus.pending,
    );
  }
}

enum TaskMode {
  play(0, 'play'),
  record(1, 'record');

  final int numericValue;
  final String descriptionKey;

  const TaskMode(this.numericValue, this.descriptionKey);

  String get description => descriptionKey.tr;

  static TaskMode fromNumericValue(int value) {
    return TaskMode.values.firstWhere(
          (mode) => mode.numericValue == value,
      orElse: () => TaskMode.play,
    );
  }
}
