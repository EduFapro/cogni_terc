import 'task_prompt_constants.dart';

class TaskPromptEntity {
  int? promptID;
  int taskID;
  String filePath;
  String? transcription;

  TaskPromptEntity({
    this.promptID,
    required this.taskID,
    required this.filePath,
    this.transcription
  });

  Map<String, dynamic> toMap() {
    return {
      ID_TASK_PROMPT: promptID,
      ID_TASK_FK: taskID,
      FILE_PATH: filePath,
      TRANSCRIPTION: transcription ?? "",
    };
  }

  static TaskPromptEntity fromMap(Map<String, dynamic> map) {
    return TaskPromptEntity(
      promptID: map[ID_TASK_PROMPT] as int?,
      taskID: map[ID_TASK_FK] as int,
      filePath: map[FILE_PATH] as String,
      transcription: map[TRANSCRIPTION],
    );
  }

  @override
  String toString() {
    return 'TaskAudioFileEntity(fileID: $promptID, taskID: $taskID, filePath: $filePath)';
  }
}
