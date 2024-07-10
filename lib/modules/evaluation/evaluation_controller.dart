import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/evaluation/evaluation_entity.dart';
import '../../app/evaluator/evaluator_entity.dart';
import '../../app/module/module_entity.dart';
import '../../app/module_instance/module_instance_entity.dart';
import '../../app/participant/participant_entity.dart';
import '../../app/task/task_entity.dart';
import '../../app/task_instance/task_instance_entity.dart';
import '../../constants/enums/evaluation_enums.dart';
import '../../constants/enums/module_enums.dart';
import '../../constants/route_arguments.dart';
import '../../routes.dart';
import '../home/home_controller.dart';
import 'evaluation_service.dart';

class EvaluationController extends GetxController {
  final EvaluationService evaluationService = Get.find<EvaluationService>();

  var participant = Rxn<ParticipantEntity>();
  var evaluation = Rxn<EvaluationEntity>();
  var evaluator = Rxn<EvaluatorEntity>();
  var modulesInstanceList = Rx<List<ModuleInstanceEntity>?>(null);
  var tasksListDetails = Rx<List<Map<int, List<TaskInstanceEntity>>>>([]);

  var isLoading = false.obs;

  var moduleCompletionStatus = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Existing initialization logic
    _initialize();

    // Add a listener to refresh UI when coming back to the screen
    ever(modulesInstanceList, (_) {
      _refreshModuleCompletionStatus();
    });
  }

  @override
  void onReady() {
    super.onReady();
    // checkAndFinalizeEvaluation();
  }

// Modify the _initialize method to check completion status of modules
  Future<void> _initialize() async {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      participant.value = arguments[RouteArguments.PARTICIPANT];
      evaluation.value = arguments[RouteArguments.EVALUATION];
      evaluator.value = arguments[RouteArguments.EVALUATOR];


      if (evaluation.value != null) {
        List<ModuleInstanceEntity>? modules = await evaluationService
            .getModuleInstancesByEvaluationId(evaluation.value!.evaluationID!);
        if (modules.isNotEmpty) {
          modulesInstanceList.value = modules;
          // Update moduleCompletionStatus based on the status of each module
          for (var module in modules) {
            moduleCompletionStatus[module.moduleInstanceID!] =
                module.status == ModuleStatus.completed;
          }
          await fetchTaskInstancesForModuleInstances(modules);
        }
      }
    }
    isLoading(false);
  }

  Future<List<ModuleEntity>?> getModulesByEvaluationId(
          int evaluationId) async =>
      await evaluationService.getModulesByEvaluationId(evaluationId);

  Future<void> fetchTaskInstancesForModuleInstances(
      List<ModuleInstanceEntity> moduleInstances) async {
    for (var moduleInstance in moduleInstances) {
      var tasks = await evaluationService
          .getTaskInstancesByModuleInstanceId(moduleInstance.moduleInstanceID!);
      if (tasks != null && tasks.isNotEmpty) {
        tasksListDetails.update((val) {
          val?.add({moduleInstance.moduleID: tasks});
        });
      }
    }
  }

  Future<void> launchNextTask(ModuleInstanceEntity moduleInstance) async {
    final nextTaskInstance = await evaluationService
        .getNextPendingTaskInstanceForModule(moduleInstance.moduleInstanceID!);
    print(nextTaskInstance);

    // If this is the first task of the evaluation, set the evaluation to in progress
    if (evaluation.value?.status == EvaluationStatus.pending) {
      evaluation.value?.status = EvaluationStatus.in_progress;
      evaluation
          .refresh(); // This will trigger UI update if `evaluation` is an Rx type
      await evaluationService
          .setEvaluationAsInProgress(evaluation.value!.evaluationID!);
      Get.find<HomeController>()
          .setEvaluationInProgress(evaluation.value!.evaluationID!);
    }

    // Update the module instance status if necessary
    if (moduleInstance.status == ModuleStatus.pending) {
      moduleInstance.status = ModuleStatus.in_progress;
      await evaluationService
          .setModuleInstanceAsInProgress(moduleInstance.moduleInstanceID!);
      updateModuleInstanceInList(
          moduleInstance.moduleInstanceID!, ModuleStatus.in_progress);
    }

    Get.find<HomeController>().refreshEvaluationCounts();

    if (nextTaskInstance != null) {
      final taskEntity = await nextTaskInstance.task;
      if (taskEntity != null) {
        navigateToTask(taskEntity, nextTaskInstance,
            moduleInstance);
      }
    } else {
      markModuleAsCompleted(moduleInstance.moduleInstanceID!);
      Get.snackbar(
        'Module Completed',
        'You have completed all tasks in this module.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: Icon(Icons.check_circle_outline, color: Colors.white),
        duration: Duration(seconds: 3),
      );
    }
  }

  void updateModuleInstanceInList(
      int moduleInstanceId, ModuleStatus newStatus) {
    final index = modulesInstanceList.value?.indexWhere(
            (element) => element.moduleInstanceID == moduleInstanceId) ??
        -1;
    if (index != -1) {
      modulesInstanceList.value![index].status = newStatus;
      modulesInstanceList.refresh();
    }
  }

  void navigateToTask(
      TaskEntity taskEntity, TaskInstanceEntity taskInstance, ModuleInstanceEntity moduleInstance) {
    print("RouteArguments.EVALUATOR: ${evaluator.value}");
    print("RouteArguments.TASK_NAME: ${taskEntity.title}");
    print("RouteArguments.TASK_ID: ${taskEntity.taskID}");
    print("RouteArguments.TASK_INSTANCE: ${taskInstance}");
    print("RouteArguments.MODULE_INSTANCE: ${moduleInstance}");
    Get.toNamed(
      AppRoutes.task,
      arguments: {
        RouteArguments.EVALUATOR: evaluator.value,
        RouteArguments.PARTICIPANT: participant.value,
        RouteArguments.TASK_NAME: taskEntity.title,
        RouteArguments.TASK: taskEntity,
        RouteArguments.TASK_INSTANCE: taskInstance,
        RouteArguments.MODULE_INSTANCE: moduleInstance,
      },
    );
  }

  // Getter for participant's age
  int get age {
    if (participant.value?.birthDate == null) return 0;
    final birthDate = participant.value!.birthDate;
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (birthDate.month > today.month ||
        (birthDate.month == today.month && birthDate.day > today.day)) {
      age--;
    }
    return age;
  }

  // Method to fetch tasks for a given module instance ID
  Future<List<TaskInstanceEntity>> getTasks(int moduleInstanceId) async {
    List<TaskInstanceEntity>? tasks = await evaluationService
        .getTaskInstancesByModuleInstanceId(moduleInstanceId);
    return tasks ?? [];
  }

  void markModuleAsCompleted(int moduleInstanceId) {
    moduleCompletionStatus[moduleInstanceId] = true;
    updateModuleInstanceInList(moduleInstanceId, ModuleStatus.completed);
    update(); // Update the UI after marking the module as completed
  }

  bool isModuleCompleted(int moduleId) {
    return moduleCompletionStatus[moduleId] ?? false;
  }

  void _refreshModuleCompletionStatus() {
    // Logic to refresh the completion status of modules
    modulesInstanceList.value?.forEach((moduleInstance) {
      // Update each module's completion status
      moduleCompletionStatus[moduleInstance.moduleInstanceID!] =
          moduleInstance.status == ModuleStatus.completed;
    });
    update(); // Trigger UI update
  }


  void refreshModuleCompletionStatus(int moduleInstanceId, ModuleStatus newStatus) {

    final moduleIndex = modulesInstanceList.value?.indexWhere(
          (module) => module.moduleInstanceID == moduleInstanceId,
    );

    if (moduleIndex != null && moduleIndex >= 0) {
      modulesInstanceList.value![moduleIndex].status = newStatus;
      moduleCompletionStatus[moduleInstanceId] = (newStatus == ModuleStatus.completed);
    }


    update();


  }

  //
  // void checkAndFinalizeEvaluation() {
  //   print("HOIHOHO");
  //   bool allModulesCompleted = modulesInstanceList.value?.every((module) {
  //         print(module);
  //         print(module.status);
  //         return module.status == ModuleStatus.completed;
  //       }) ??
  //       false;
  //   print("ASDSAD");
  //   if (allModulesCompleted) {
  //     var evalId = evaluation.value?.evaluationID;
  //     if (evalId != null) {
  //       evaluationService.setEvaluationAsCompleted(evalId).then((_) {
  //         evaluation.value?.status = EvaluationStatus.completed;
  //         evaluation.refresh();
  //         Get.find<HomeController>().refreshEvaluations();
  //         Get.find<HomeController>().refreshEvaluationCounts();
  //       });
  //     }
  //   }
  // }
}
