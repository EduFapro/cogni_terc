import '../../app/evaluation/evaluation_repository.dart';
import '../../app/module/module_entity.dart';
import '../../app/module/module_repository.dart';
import '../../app/module_instance/module_instance_entity.dart';
import '../../app/module_instance/module_instance_repository.dart';
import '../../app/task/task_repository.dart';
import '../../app/task_instance/task_instance_entity.dart';
import '../../app/task_instance/task_instance_repository.dart';
import '../../constants/enums/module_enums.dart';
import '../../constants/enums/task_enums.dart';

class EvaluationService {
  final EvaluationRepository evaluationRepository;
  final ModuleRepository moduleRepository;
  final TaskRepository taskRepository;
  final TaskInstanceRepository taskInstanceRepository;
  final ModuleInstanceRepository moduleInstanceRepository;

  EvaluationService(
      {required this.moduleRepository,
      required this.evaluationRepository,
      required this.taskRepository,
      required this.moduleInstanceRepository,
      required this.taskInstanceRepository});

  Future<List<ModuleInstanceEntity>> getModuleInstancesByEvaluationId(
      int evaluationId) async {
    try {
      // Call the repository to fetch module instances by evaluation ID
      List<ModuleInstanceEntity> moduleInstances =
          await moduleInstanceRepository
              .getModuleInstancesByEvaluationId(evaluationId);

      if (moduleInstances.isEmpty) {
        print("No module instances found for evaluation ID: $evaluationId");
      }

      return moduleInstances;
    } catch (e) {
      // Log any errors for debugging
      print(
          'Error fetching module instances for evaluation ID $evaluationId: $e');
      return []; // Return an empty list on error to prevent app crash
    }
  }

  Future<List<ModuleEntity>> getModulesByEvaluationId(int evaluationId) async {
    try {
      List<ModuleInstanceEntity> moduleInstances =
          await moduleInstanceRepository
              .getModuleInstancesByEvaluationId(evaluationId);

      List<ModuleEntity> modules = [];

      for (var moduleInstance in moduleInstances) {
        var module = await moduleRepository.getModule(moduleInstance.moduleID);
        if (module != null) {
          modules.add(module);
        }
      }
      return modules;
    } catch (e) {
      print('Error fetching modules for evaluation: $evaluationId $e');
      return [];
    }
  }

  Future<List<TaskInstanceEntity>?> getTaskInstancesByModuleInstanceId(
      int moduleId) async {
    print("moduleId in getTasksByModuleId in eval_service: $moduleId ");
    try {
      List<TaskInstanceEntity> taskInstanceList = await taskInstanceRepository
          .getTaskInstancesForModuleInstance(moduleId);

      return taskInstanceList;
    } catch (e) {
      print('Error fetching tasks for module: $moduleId $e');
      return null;
    }
  }

  Future<List<ModuleInstanceEntity>> getModulesInstanceByEvaluationId(
      int evaluationId) async {
    try {
      List<ModuleInstanceEntity> moduleInstances =
          await moduleInstanceRepository
              .getModuleInstancesByEvaluationId(evaluationId);

      List<ModuleEntity> modules = [];

      for (var moduleInstance in moduleInstances) {
        var module = await moduleRepository.getModule(moduleInstance.moduleID);
        if (module != null) {
          modules.add(module);
        }
      }
      return moduleInstances;
    } catch (e) {
      print('Error fetching modules for evaluation: $evaluationId $e');
      return [];
    }
  }

  Future<TaskInstanceEntity?> getNextPendingTaskInstanceForModule(
      int moduleInstanceId) async {
    try {
      List<TaskInstanceEntity> taskInstances = await taskInstanceRepository
          .getTaskInstancesForModuleInstance(moduleInstanceId);
      TaskInstanceEntity? nextPendingTask;
      // Check for the first task instance with a pending status.
      for (TaskInstanceEntity taskInstance in taskInstances) {
        if (taskInstance.status == TaskStatus.pending) {
          nextPendingTask = taskInstance;
          break;
        }
      }
      return nextPendingTask;
    } catch (e) {
      print(
          'Error fetching next pending task instance for module instance ID $moduleInstanceId: $e');
      return null;
    }
  }

  // EvaluationService
  Future<TaskInstanceEntity?> getNextTaskInstanceSkippingCurrent(
      int moduleInstanceId, int currentTaskInstanceId) async {
    try {
      List<TaskInstanceEntity> taskInstances = await taskInstanceRepository
          .getTaskInstancesForModuleInstance(moduleInstanceId);
      TaskInstanceEntity? nextTask;
      bool currentTaskSkipped = false;
      for (var taskInstance in taskInstances) {
        if (taskInstance.taskInstanceID == currentTaskInstanceId) {
          currentTaskSkipped = true;
          continue; // Skip the current task instance
        }
        if (currentTaskSkipped && taskInstance.status == TaskStatus.pending) {
          nextTask = taskInstance;
          break;
        }
      }
      return nextTask;
    } catch (e) {
      print('Error fetching next task instance skipping current for module instance ID $moduleInstanceId: $e');
      return null;
    }
  }


  Future<int> setModuleInstanceAsCompleted(int moduleInstanceId) {
    return moduleInstanceRepository
        .setModuleInstanceAsCompleted(moduleInstanceId);
  }

  Future<int> setModuleInstanceAsInProgress(int moduleInstanceId) {
    return moduleInstanceRepository
        .setModuleInstanceAsInProgress(moduleInstanceId);
  }

  Future<void> setEvaluationAsCompleted(int evaluationId) {
    return evaluationRepository.setEvaluationAsCompleted(evaluationId);
  }

  Future<void> setEvaluationAsInProgress(int evaluationId) {
    return evaluationRepository.setEvaluationAsInProgress(evaluationId);
  }

  Future<bool> areAllModulesCompleted(int evaluationId) async {
    try {
      List<ModuleInstanceEntity> moduleInstances =
          await moduleInstanceRepository
              .getModuleInstancesByEvaluationId(evaluationId);
      // Check if every module instance associated with the evaluation is completed
      return moduleInstances.every(
          (moduleInstance) => moduleInstance.status == ModuleStatus.completed);
    } catch (e) {
      print('Error checking if all modules are completed: $e');
      return false;
    }
  }
}
