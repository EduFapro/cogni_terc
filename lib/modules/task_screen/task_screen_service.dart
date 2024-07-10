import '../../app/task/task_entity.dart';
import '../../app/task/task_repository.dart';
import '../../app/task_instance/task_instance_entity.dart';
import '../../app/task_instance/task_instance_repository.dart';
import '../../app/task_prompt/task_prompt_entity.dart';
import '../../app/task_prompt/task_prompt_repository.dart';
import '../../constants/enums/task_enums.dart';

class TaskScreenService {
  final TaskPromptRepository taskPromptRepository;
  final TaskInstanceRepository taskInstanceRepository;
  final TaskRepository taskRepository;

  TaskScreenService({
    required this.taskPromptRepository,
    required this.taskInstanceRepository,
    required this.taskRepository,
  });

  Future<TaskPromptEntity?> getTaskPromptByTaskInstanceID(
      int taskInstanceId) async {
    try {
      // Log the start of the operation
      print('Fetching task prompt for task instance ID: $taskInstanceId');

      // Retrieve the task prompt
      final taskPrompt = await taskPromptRepository
          .getTaskPromptByTaskInstanceID(taskInstanceId);
      print("DENTRO TASK SERVICE");
      // Check if the task prompt was successfully retrieved
      if (taskPrompt != null) {
        // Log the successful retrieval
        print('Task prompt retrieved: ${taskPrompt.filePath}');
        return taskPrompt;
      } else {
        // Log the case where no task prompt was found
        print('No task prompt found for task instance ID: $taskInstanceId');
        return null;
      }
    } catch (e) {
      print(
          'Error fetching task prompt for task instance ID: $taskInstanceId: $e');
      return null;
    }
  }

// New method to get a task instance
  Future<TaskInstanceEntity?> getTaskInstance(int taskInstanceId) async {
    return await taskInstanceRepository.getTaskInstance(taskInstanceId);
  }

  Future<bool> updateTaskInstance(TaskInstanceEntity taskInstance) async {
    int result = await taskInstanceRepository.updateTaskInstance(taskInstance);
    return result > 0;
  }

  // Future<TaskInstanceEntity?> getFirstPendingTaskInstance() async {
  //   try {
  //     // Assuming 'getAllTaskInstances' returns all task instances
  //     List<TaskInstanceEntity> taskInstances =
  //         await taskInstanceRepository.getAllTaskInstances();
  //
  //     // Find the first task instance with a 'pending' status
  //     for (var taskInstance in taskInstances) {
  //       if (taskInstance.status == TaskStatus.pending) {
  //         return taskInstance;
  //       }
  //     }
  //
  //     return null;
  //   } catch (e) {
  //     print("Error in getFirstPendingTaskInstance: $e");
  //     return null;
  //   }
  // }

  Future<List<TaskEntity>> getAllTasks() async {
    return taskRepository.getAllTasks();
  }

  Future<TaskEntity?> getTask(int taskId) async {
    try {
      return await taskRepository.getTask(taskId);
    } catch (e) {
      print("Error fetching task with ID: $taskId: $e");
      return null;
    }
  }

  // Inside TaskService class

  Future<List<TaskInstanceEntity>> getTasksByModuleInstanceId(int moduleInstanceId) async {
    try {
      // Call the repository to fetch task instances by module instance ID
      List<TaskInstanceEntity> taskInstances = await taskInstanceRepository.getTaskInstancesByModuleInstanceId(moduleInstanceId);

      return taskInstances;
    } catch (e) {
      // Log any errors for debugging
      print('Error fetching task instances for module instance ID $moduleInstanceId: $e');
      return []; // Return an empty list on error to prevent app crash
    }
  }

}
