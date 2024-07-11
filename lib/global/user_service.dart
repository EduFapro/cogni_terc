import 'package:get/get.dart';

import '../app/evaluation/evaluation_entity.dart';
import '../app/evaluation/evaluation_repository.dart';
import '../app/evaluator/evaluator_entity.dart';
import '../app/evaluator/evaluator_repository.dart';
import '../app/module/module_repository.dart';
import '../app/module_instance/module_instance_entity.dart';
import '../app/module_instance/module_instance_repository.dart';
import '../app/participant/participant_entity.dart';
import '../app/participant/participant_repository.dart';
import '../app/task_instance/task_instance_entity.dart';
import '../app/task_instance/task_instance_repository.dart';
import 'typedefs.dart';

class UserService extends GetxController {
  var evaluatorRepo = Get.find<EvaluatorRepository>();
  var evaluationRepo = Get.find<EvaluationRepository>();
  var participantRepo = Get.find<ParticipantRepository>();
  var moduleRepo = Get.find<ModuleRepository>();
  var moduleInstanceRepo = Get.find<ModuleInstanceRepository>();
  var taskInstanceRepo = Get.find<TaskInstanceRepository>();

  Rx<EvaluatorEntity?> user = Rxn<EvaluatorEntity>();
  Rx<EvaluationMap> evaluationMap = Rx<EvaluationMap>({});

  Rx<TaskInstanceList> taskInstanceList = Rx<TaskInstanceList>([]);
  Rx<ModuleInstanceMap> moduleInstanceMap = Rx<ModuleInstanceMap>({});

  var evaluations = <EvaluationEntity>[].obs;
  var participants = <ParticipantEntity>[].obs;
  var modules = <int, List<ModuleInstanceEntity>>{}.obs;

  bool get isUserAdmin {
    return user.value?.isAdmin ?? false;
  }


  // Fetch user data and organize the data structure
  Future<void> fetchUserData(int? userId) async {
    if (userId == null) return;

    try {
      EvaluatorEntity? fetchedUser = await evaluatorRepo.getEvaluator(userId);
      if (fetchedUser != null) {
        user.value = fetchedUser;
        await fetchAndOrganizeEvaluations(fetchedUser);
      }
    } catch (e) {
      // Handle error, log it or show a message to the user
      print("Error fetching user data: $e");
    }
  }

  // Fetch evaluations and organize them into the map
  Future<void> fetchAndOrganizeEvaluations(EvaluatorEntity userEntity) async {
    evaluations.value = await evaluationRepo
        .getEvaluationsByEvaluatorID(userEntity.evaluatorID!);
    await fetchParticipantsForEvaluations(evaluations);
    await organizeEvaluationMap();
  }

  // Organize evaluations, module instances, and task instances into the map
  Future<void> organizeEvaluationMap() async {
    EvaluationMap tempMap = {};

    for (var evaluation in evaluations) {
      tempMap[evaluation] = await fetchModuleInstanceMap(evaluation);
    }

    evaluationMap.value = tempMap;
  }

  // Fetch module instances and their corresponding task instances for a given evaluation
  Future<ModuleInstanceMap> fetchModuleInstanceMap(
      EvaluationEntity evaluation) async {
    ModuleInstanceMap tempModuleInstanceMap = {};

    List<ModuleInstanceEntity> moduleInstances = await moduleInstanceRepo
        .getModuleInstancesByEvaluationId(evaluation.evaluationID!);
    for (var moduleInstance in moduleInstances) {
      tempModuleInstanceMap[moduleInstance] = await taskInstanceRepo
          .getTaskInstancesByModuleInstanceId(moduleInstance.moduleInstanceID!);
    }

    return tempModuleInstanceMap;
  }

  Future<EvaluatorEntity?> getUser(int id) async {
    return await evaluatorRepo.getEvaluator(id);
  }

  Future<void> organizeDataStructure(int userId) async {
    // Temporary local map to organize data
    EvaluationMap tempEvaluationMap = {};

    var user = await getUser(userId);
    if (user == null) {
      evaluationMap.value = {};
      return;
    }

    var userEvaluations = await getEvaluationsByUser(user);
    for (var evaluation in userEvaluations) {
      ModuleInstanceMap moduleInstanceMap = {};

      var moduleInstances = await getModuleInstancesByEvaluation(evaluation);
      for (var moduleInstance in moduleInstances) {
        var taskInstances =
        await getTaskInstancesForModuleInstance(moduleInstance);
        moduleInstanceMap[moduleInstance] = taskInstances;
      }

      tempEvaluationMap[evaluation] = moduleInstanceMap;
    }

    // Update the observable map with the new data
    evaluationMap.value = tempEvaluationMap;
    print("evaluation.map: ${evaluationMap.value}");
  }

  Future<List<EvaluationEntity>> getEvaluationsByUser(
      EvaluatorEntity user) async {
    var evaluations =
    await evaluationRepo.getEvaluationsByEvaluatorID(user.evaluatorID!);
    return evaluations;
  }

  Future<Map<int, List<ModuleInstanceEntity>>> getModuleMapsForEvaluation(
      EvaluationEntity evaluation) async {
    // Retrieve all module instances for the given evaluation ID.
    List<ModuleInstanceEntity> moduleInstances = await moduleInstanceRepo
        .getModuleInstancesByEvaluationId(evaluation.evaluationID!);

    // Initialize an empty map to organize module instances by module ID.
    Map<int, List<ModuleInstanceEntity>> modulesMap = {};

    // Iterate over each module instance.
    for (var instance in moduleInstances) {
      // Check if the module ID is already a key in the map. If not, initialize an empty list.
      modulesMap.putIfAbsent(instance.moduleID, () => []);

      // Add the module instance to the list corresponding to its module ID.
      modulesMap[instance.moduleID]!.add(instance);
    }

    return modulesMap;
  }

  Future<List<ModuleInstanceEntity>> getModuleInstancesByEvaluation(
      EvaluationEntity evaluation) async {
    return await moduleInstanceRepo
        .getModuleInstancesByEvaluationId(evaluation.evaluationID!);
  }

  Future<TaskInstanceList> getTaskInstancesForModuleInstance(
      ModuleInstanceEntity moduleInstance) async {
    return await taskInstanceRepo
        .getTaskInstancesByModuleInstanceId(moduleInstance.moduleInstanceID!);
  }


  Future<void> updateUser(EvaluatorEntity newUser) async {
    user.value = newUser;
    await fetchUserData(newUser.evaluatorID);
  }

  Future<void> fetchParticipantsForEvaluations(
      List<EvaluationEntity> evaluationsList) async {
    List<ParticipantEntity> fetchedParticipants = [];
    for (var evaluation in evaluationsList) {
      try {
        ParticipantEntity? participant = await participantRepo
            .getParticipantByEvaluation(evaluation.evaluationID!);
        if (participant != null) {
          fetchedParticipants.add(participant);
        }
      } catch (e) {
        print(
            "Error fetching participant data for evaluation ${evaluation.evaluationID}: $e");
      }
    }
    participants.assignAll(fetchedParticipants);
  }

  // UserService
  Future<List<ParticipantEntity>> fetchUpdatedParticipants() async {
    var updatedParticipants = await participantRepo.getAllParticipants();
    return updatedParticipants;
  }

  Future<EvaluationEntity> deleteEvaluation(
      EvaluationEntity evaluation)  async {
    // Fetch all module instances associated with the evaluation
    var moduleInstancesList = await moduleInstanceRepo
        .getModuleInstancesByEvaluationId(evaluation.evaluationID!);
    print('Module Instances List: $moduleInstancesList');

    // List to store all task instances from all module instances
    List<TaskInstanceEntity> taskInstancesList = [];

    // Iterate over each module instance
    for (ModuleInstanceEntity moduleInstance in moduleInstancesList) {
      print('Processing Module Instance: $moduleInstance');

      // Fetch task instances for the current module instance
      var taskInstances = await taskInstanceRepo
          .getTaskInstancesForModuleInstance(moduleInstance.moduleInstanceID!);
      print(
          'Task Instances for Module Instance ID ${moduleInstance.moduleInstanceID}: $taskInstances');

      // Add the fetched task instances to the list
      taskInstancesList.addAll(taskInstances);
    }

    for (var e in taskInstancesList) {
      taskInstanceRepo.deleteTaskInstance(e.taskInstanceID!);
    }
    for (var e in moduleInstancesList) {
      moduleInstanceRepo.deleteModuleInstance(e.moduleInstanceID!);
    }
    var deletedEvaluation = await evaluationRepo.getEvaluation(evaluation.evaluationID!);
    evaluationRepo.deleteEvaluation(evaluation.evaluationID!);
    participantRepo.deleteParticipant(evaluation.participantID);

    print('All Task Instances: $taskInstancesList');

    return deletedEvaluation!;
  }
}
