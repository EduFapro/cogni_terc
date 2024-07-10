import 'task_instance_local_datasource.dart';
import 'task_instance_entity.dart';

class TaskInstanceRepository {
  final TaskInstanceLocalDataSource _localDataSource;

  TaskInstanceRepository({required TaskInstanceLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  // Create a Task Instance
  Future<int?> createTaskInstance(TaskInstanceEntity taskInstance) async {
    return await _localDataSource.create(taskInstance);
  }

  // Get a Task Instance by ID
  Future<TaskInstanceEntity?> getTaskInstance(int id) async {
    return await _localDataSource.getTaskInstance(id);
  }

  // Update a Task Instance
  Future<int> updateTaskInstance(TaskInstanceEntity taskInstance) async {
    return await _localDataSource.updateTaskInstance(taskInstance);
  }

  // Delete a Task Instance by ID
  Future<int> deleteTaskInstance(int id) async {
    return await _localDataSource.deleteTaskInstance(id);
  }

  // List all Task Instances
  Future<List<TaskInstanceEntity>> getAllTaskInstances() async {
    return await _localDataSource.getAllTaskInstances();
  }

  // Get Task Instances for a specific Module Instance
  Future<List<TaskInstanceEntity>> getTaskInstancesForModuleInstance(int moduleInstanceId) async {
    return await _localDataSource.getTaskInstancesForModuleInstance(moduleInstanceId);
  }

  // // Get the first pending Task Instance
  // Future<TaskInstanceEntity?> getFirstPendingTaskInstance() async {
  //   return await _localDataSource.getFirstPendingTaskInstance();
  // }

  Future<List<TaskInstanceEntity>> getTaskInstancesByModuleInstanceId(int moduleInstanceId) async {
    return await _localDataSource.getTaskInstancesForModuleInstance(moduleInstanceId);
  }

}
