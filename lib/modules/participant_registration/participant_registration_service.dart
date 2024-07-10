import '../../app/participant/participant_entity.dart';
import '../../app/participant/participant_repository.dart';
import '../../app/task_instance/task_instance_entity.dart';
import '../../app/task_instance/task_instance_repository.dart';
import '../../app/task/task_repository.dart';
import '../../app/evaluation/evaluation_entity.dart';
import '../../app/evaluation/evaluation_repository.dart';
import '../../app/module/module_entity.dart';
import '../../app/module/module_repository.dart';
import '../../app/module_instance/module_instance_entity.dart';
import '../../app/module_instance/module_instance_repository.dart';
import '../../constants/enums/language_enums.dart';

class ParticipantRegistrationService {
  final ParticipantRepository participantRepository;
  final EvaluationRepository evaluationRepository;
  final ModuleRepository moduleRepository;
  final ModuleInstanceRepository moduleInstanceRepository;
  final TaskRepository taskRepository;
  final TaskInstanceRepository taskInstanceRepository;

  ParticipantRegistrationService({
    required this.participantRepository,
    required this.evaluationRepository,
    required this.moduleRepository,
    required this.taskRepository,
    required this.taskInstanceRepository,
    required this.moduleInstanceRepository,
  });

  Future<int?> createParticipant(int evaluatorId, List<String> selectedModules,
      ParticipantEntity newParticipant) async {
    int? participantId =
        await participantRepository.createParticipant(newParticipant);
    return participantId;
  }

  Future<int?> createEvaluation(
      int participantId, int evaluatorId, Language selectedLanguage) async {
    EvaluationEntity evaluation = EvaluationEntity(
      participantID: participantId,
      evaluatorID: evaluatorId,
      language: selectedLanguage.numericValue,
    );

    int? evaluationId = await evaluationRepository.createEvaluation(evaluation);
    return evaluationId;
  }

  Future<List<int>> saveModules(List<ModuleEntity> modules) async {
    List<int> moduleIds = [];
    for (var module in modules) {
      int? id = await moduleRepository.createModule(module);
      if (id != null) {
        moduleIds.add(id);
      }
    }
    return moduleIds;
  }

  Future<List<ModuleInstanceEntity>> linkEvaluationToModules(
      int evaluationId, List<int> moduleIds) async {
    var moduleInstances = moduleIds.map((moduleId) {
      var newModuleInstance =
          ModuleInstanceEntity(moduleID: moduleId, evaluationID: evaluationId);
      return moduleInstanceRepository.createModuleInstance(newModuleInstance);
    });

    var results = await Future.wait(moduleInstances);
    return results.whereType<ModuleInstanceEntity>().toList();
  }

  Future<List<TaskInstanceEntity>> linkTaskInstancesToModuleInstances(
      ModuleInstanceEntity moduleInstance, ModuleEntity module) async {
    print(
        "Linking task instances for module instance ID: ${moduleInstance.moduleInstanceID}");

    var tasks = module.tasks.map((task) async {
      try {
        print("Creating task instance for task ID: ${task.taskID}");
        var taskInstance = TaskInstanceEntity(
          taskID: task.taskID!,
          moduleInstanceID: moduleInstance.moduleInstanceID!,
        );

        return await taskInstanceRepository.createTaskInstance(taskInstance);
      } catch (e) {
        print("Error creating task instance for task ID ${task.taskID}: $e");
        return null; // Return null in case of error
      }
    }).toList();

    try {
      var results = await Future.wait(tasks);
      return results
          .whereType<TaskInstanceEntity>()
          .toList(); // Filter out null values
    } catch (e) {
      print("Error during Future.wait: $e");
      return [];
    }
  }

  Future<Map<String, int>> createParticipantAndModules(
      int evaluatorId,
      List<String> selectedModules,
      ParticipantEntity newParticipant,
      Language selectedLanguage) async {
    int? participantId =
        await createParticipant(evaluatorId, selectedModules, newParticipant);

    if (participantId == null) return {};

    int? evaluationId =
        await createEvaluation(participantId, evaluatorId, selectedLanguage);

    if (evaluationId == null) return {};

    List<int> moduleIds = await fetchModuleIds(selectedModules);
    var moduleInstances =
        await linkEvaluationToModules(evaluationId, moduleIds);

    for (var moduleInstance in moduleInstances) {
      var module =
          await moduleRepository.getModuleWithTasks(moduleInstance.moduleID);
      print("Each module: $module");
      if (module != null) {
        await linkTaskInstancesToModuleInstances(moduleInstance, module);
      }
    }

    return {
      "participantId": participantId,
      "evaluationId": evaluationId,
    };
  }

  Future<List<int>> fetchModuleIds(List<String> selectedModules) async {
    List<Future<int>> futures = selectedModules.map((name) async {
      var module = await moduleRepository.getModuleByName(name);
      print("module: $module");
      if (module != null && module.moduleID != null) {
        return module.moduleID!;
      } else {
        throw Exception("Module or module ID is null for module: $name");
      }
    }).toList();

    return await Future.wait(futures);
  }
}
