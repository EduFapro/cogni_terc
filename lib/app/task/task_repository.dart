
import 'task_entity.dart';
import 'task_local_datasource.dart';

class TaskRepository {
  final TaskLocalDataSource _localDataSource;

  TaskRepository({required TaskLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  // Create a Task
  Future<int?> createTask(TaskEntity task) async {
    return await _localDataSource.create(task);
  }

// Get a Task by ID
  Future<TaskEntity?> getTask(int id) async {
    return await _localDataSource.getTask(id);
  }

// List tasks by Module ID
  Future<List<TaskEntity>> getTasksForModule(int moduleId) async {
    return await _localDataSource.listTasksByModuleId(moduleId);
  }

  // Update a Task
  Future<int> updateTask(TaskEntity task) async {
    return await _localDataSource.updateTask(task);
  }

  // Delete a Task by ID
  Future<int> deleteTask(int id) async {
    return await _localDataSource.deleteTask(id);
  }

  // List all Tasks
  Future<List<TaskEntity>> getAllTasks() async {
    return await _localDataSource.listTasks();
  }
}
