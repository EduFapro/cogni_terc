import '../../../constants/enums/task_enums.dart';
import 'task_constants.dart';

class TaskEntity {
  int? taskID;
  int moduleID;
  String title;
  String? snakeCaseBriefTranscript;
  TaskMode taskMode;
  int position;
  String? image_path;
  int timeForCompletion;
  bool mayRepeatPrompt;
  bool test_only;

  TaskEntity({
    this.taskID,
    required this.moduleID,
    required this.title,
    required this.taskMode,
    required this.position,
    this.image_path,
    this.timeForCompletion = 30,
    this.mayRepeatPrompt = true,
    this.test_only = false,
    this.snakeCaseBriefTranscript,
  });

  Map<String, dynamic> toMap() {
    return {
      ID_TASK: taskID,
      TITLE: title,
      SNAKE_CASE_BRIEF_TRANSCRIPT: snakeCaseBriefTranscript,
      MODULE_ID: moduleID,
      MODE: taskMode.numericValue,
      POSITION: position,
      IMAGE_PATH: image_path,
      TIME_FOR_COMPLETION: timeForCompletion,
      MAY_REPEAT_PROMPT: mayRepeatPrompt ? 1 : 0,
      TEST_ONLY: test_only ? 1 : 0,
    };
  }

  static TaskEntity fromMap(Map<String, dynamic> map) {
    final mode = TaskMode.fromNumericValue(map[MODE] as int);
    return TaskEntity(
        taskID: map[ID_TASK] as int?,
        title: map[TITLE] as String,
        snakeCaseBriefTranscript: map[SNAKE_CASE_BRIEF_TRANSCRIPT],
        moduleID: map[MODULE_ID] as int,
        taskMode: mode,
        position: map[POSITION] as int,
        image_path: map[IMAGE_PATH] as String?,
        timeForCompletion: map[TIME_FOR_COMPLETION],
        mayRepeatPrompt: map[MAY_REPEAT_PROMPT] == 1 ? true : false,
        test_only: map[MAY_REPEAT_PROMPT] == 1 ? true : false);
  }

  @override
  String toString() {
    return 'TaskEntity{'
        'task_id: $taskID, '
        'title: "$title", '
        'taskMode: ${taskMode.description}, '
        'position: $position, '
        'image_path: "$image_path,'
        'imeForCompletion: $timeForCompletion'
        '}';
  }
}
