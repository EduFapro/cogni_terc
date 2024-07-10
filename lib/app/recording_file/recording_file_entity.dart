

import 'recording_file_constants.dart';

class RecordingFileEntity {
  final int? recordingId;
  final int taskInstanceId;
  final String filePath;

  RecordingFileEntity({
    this.recordingId,
    required this.taskInstanceId,
    required this.filePath,
  });

  Map<String, dynamic> toMap() {
    return {
      ID_RECORDING: recordingId,
      ID_TASK_INSTANCE_FK: taskInstanceId,
      FILE_PATH: filePath,
    };
  }

  static RecordingFileEntity fromMap(Map<String, dynamic> map) {
    return RecordingFileEntity(
      recordingId: map[ID_RECORDING] as int?,
      taskInstanceId: map[ID_TASK_INSTANCE_FK] as int,
      filePath: map[FILE_PATH] as String,
    );
  }

  @override
  String toString() {
    return 'TaskPromptEntity{recordingId: $recordingId, taskInstanceId: $taskInstanceId, filePath: $filePath}';
  }
}
