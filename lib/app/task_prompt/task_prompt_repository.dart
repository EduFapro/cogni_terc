import 'task_prompt_entity.dart';
import 'task_prompt_local_datasource.dart';

class TaskPromptRepository {
  final TaskPromptLocalDataSource localDataSource;

  TaskPromptRepository({required this.localDataSource});

  Future<int?> create(TaskPromptEntity taskPrompt) async {
    return localDataSource.create(taskPrompt);
  }

  Future<TaskPromptEntity?> getTaskPrompt(int id) async {
    return localDataSource.getTaskPrompt(id);
  }

  Future<int> updateTaskPrompt(TaskPromptEntity taskPrompt) async {
    return localDataSource.updateTaskPrompt(taskPrompt);
  }

  Future<int> deleteTaskPrompt(int id) async {
    return localDataSource.deleteTaskPrompt(id);
  }

  Future<List<TaskPromptEntity>> getAllTaskPrompts() async {
    return localDataSource.getAllTaskPrompts();
  }

  Future<TaskPromptEntity?> getTaskPromptByTaskInstanceID(int taskID) async {
    return localDataSource.getTaskPromptByTaskID(taskID);
  }

}
