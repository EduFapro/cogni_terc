// import 'package:get/get.dart';
// import 'package:novo_cogni/global/typedefs.dart';
// import 'package:novo_cogni/global/user_service.dart';
// import '../app/module_instance/module_instance_entity.dart';
// import '../app/participant/participant_entity.dart';
// import '../app/participant/participant_repository.dart';
// import '../app/evaluation/evaluation_entity.dart';
// import '../app/evaluator/evaluator_entity.dart';
// import '../app/evaluator/evaluator_repository.dart';
//
// class UserController extends GetxController {
//   Rx<EvaluatorEntity?> user = Rxn<EvaluatorEntity>();
//
//   var evaluatorRepo = Get.find<EvaluatorRepository>();
//   var userService = Get.find<UserService>();
//   var participantRepo = Get.find<ParticipantRepository>();
//
//   var evaluations = <EvaluationEntity>[].obs;
//   var participants = <ParticipantEntity>[].obs;
//   var participantDetails = <int, ParticipantEntity>{}.obs;
//   var modules =
//       <int, List<ModuleInstanceEntity>>{}.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//   }
//
//   Future<void> fetchUserData() async {
//     int? currentUserId = user.value?.evaluatorID;
//     if (currentUserId == null) {
//       return;
//     }
//     await _organizeDataStructure();
//   }
//
//   Future<void> _organizeDataStructure() async {
//     var userEvaluations = await userService.getEvaluationsByUser(user.value!);
//     evaluations.assignAll(userEvaluations);
//
//     EvaluationMap evaluationMap = {};
//
//     for (var evaluation in userEvaluations) {
//       ModuleInstanceMap moduleInstanceMap = {};
//
//       List<ModuleInstanceEntity> moduleInstances = await userService
//           .getModuleInstancesByEvaluation(evaluation);
//       for (var moduleInstance in moduleInstances) {
//         TaskInstanceList taskInstances = await userService
//             .getTaskInstancesForModuleInstance(moduleInstance);
//         moduleInstanceMap[moduleInstance] = taskInstances;
//       }
//
//       evaluationMap[evaluation] = moduleInstanceMap;
//     }
//   }
//
//   Future<void> _fetchAndSetUser(int currentUserId) async {
//     try {
//       var fetchedUser = await userService.getUser(currentUserId);
//       if (fetchedUser != null) {
//         user.value = fetchedUser;
//       } else {
//         print("Fetched user is null");
//       }
//     } catch (e) {
//       print("Error fetching user data: $e");
//     }
//   }
//
//   Future<void> _fetchAndSetEvaluations() async {
//     if (user.value == null) return;
//
//     try {
//       var fetchedEvaluations =
//           await userService.getEvaluationsByUser(user.value!);
//       evaluations.assignAll(fetchedEvaluations);
//       await _fetchAndSetParticipants(fetchedEvaluations);
//     } catch (e) {
//       print("Error fetching evaluations: $e");
//     }
//   }
//
//   Future<void> _fetchAndSetParticipants(
//       List<EvaluationEntity> evaluations) async {
//     for (var evaluation in evaluations) {
//       var participant = await participantRepo
//           .getParticipantByEvaluation(evaluation.evaluationID!);
//       if (participant != null) {
//         participants.add(participant);
//         participantDetails[evaluation.evaluationID!] = participant;
//       }
//     }
//   }
//
//   Future<void> updateUser(EvaluatorEntity newUser) async {
//     user.value = newUser;
//     await fetchUserData();
//   }
//
//   Future<EvaluatorEntity?> getCurrentUserOrFetch() async {
//     if (user.value == null) {
//       await fetchUserData();
//     }
//     return user.value;
//   }
//
//   bool get isUserAdmin {
//     return user.value?.isAdmin ?? false;
//   }
//
//   Future<void> _getModuleMapsForEvaluations() async {
//     var tempModules = <int, List<ModuleInstanceEntity>>{};
//
//     for (var evaluation in evaluations) {
//       var moduleMap = await userService.getModuleMapsForEvaluation(evaluation);
//
//       // Iterate over each entry in the moduleMap and add it to the tempModules map
//       moduleMap.forEach((moduleId, moduleInstances) {
//         // If the moduleId already exists in tempModules, append the moduleInstances to the existing list
//         if (tempModules.containsKey(moduleId)) {
//           tempModules[moduleId]!.addAll(moduleInstances);
//         } else {
//           // If the moduleId doesn't exist, simply add the new entry
//           tempModules[moduleId] = moduleInstances;
//         }
//       });
//     }
//
//     // Since `modules` is an observable, update it with the accumulated tempModules
//     modules.value = tempModules;
//   }
//
//
// }
