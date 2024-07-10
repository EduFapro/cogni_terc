import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

import '../../app/evaluation/evaluation_entity.dart';
import '../../app/evaluator/evaluator_entity.dart';
import '../../app/module_instance/module_instance_entity.dart';
import '../../app/module_instance/module_instance_repository.dart';
import '../../app/participant/participant_entity.dart';
import '../../app/recording_file/recording_file_entity.dart';
import '../../app/recording_file/recording_file_repository.dart';
import '../../app/task_instance/task_instance_entity.dart';
import '../../app/task_instance/task_instance_repository.dart';
import '../../constants/enums/evaluation_enums.dart';
import '../../constants/enums/language_enums.dart';
import '../../file_management/evaluation_download.dart';
import '../../file_management/file_encryptor.dart';
import '../../global/user_service.dart';
import '../eval_data/eval_data_service.dart';

class HomeController extends GetxController {
  final UserService userService = Get.find<UserService>();
  final FileEncryptor fileEncryptor = Get.find<FileEncryptor>();
  var isLoading = false.obs;
  var user = Rxn<EvaluatorEntity>();

  var evaluations = RxList<EvaluationEntity>();
  var participants = RxList<ParticipantEntity>();
  var participantDetails = RxMap<int, ParticipantEntity>();

  var numEvaluationsInProgress = RxInt(0);
  var numEvaluationsFinished = RxInt(0);
  var numEvaluationsTotal = RxInt(0);

  var moduleInstanceRepository = Get.find<ModuleInstanceRepository>();
  var taskInstanceRepository = Get.find<TaskInstanceRepository>();
  var recordingRepository = Get.find<RecordingRepository>();
  var evalDataService = Get.find<EvalDataService>();

  var selectedStatus = Rxn<EvaluationStatus?>(null);
  var filteredEvaluations = RxList<EvaluationEntity>();
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    print("HomeController initialized");
    setupListeners();
    fetchData().then((_) {

      filteredEvaluations.assignAll(evaluations);
    });
    numEvaluationsTotal.value = evaluations.length;

    ever(selectedStatus, (_) => filterEvaluationsByStatus());
    ever(
        evaluations,
        (_) => {
              // Ensure filteredEvaluations is updated whenever evaluations list changes
              filterEvaluationsByStatus()
            });
    searchController.addListener(() {
      performSearch(searchController.text);
    });
  }

  @override
  void onReady() {
    super.onReady();
    refreshEvaluations();
  }

  void resetFilters() {
    if (selectedStatus.value == null && searchController.text.isEmpty) {
      filteredEvaluations.assignAll(evaluations);
    } else {
      filterEvaluationsByStatus();
    }
    update();
  }

  void setupListeners() {
    ever(userService.user, (EvaluatorEntity? newUser) {
      user.value = newUser;
      update();
    });

    ever(userService.evaluations, (List<EvaluationEntity> newEvaluations) {
      evaluations.assignAll(newEvaluations);
      numEvaluationsTotal.value = newEvaluations.length;
      refreshEvaluationCounts();
      update();
    });

    ever(userService.participants, (List<ParticipantEntity> newParticipants) {
      participants.assignAll(newParticipants);
      update();
    });

    searchController.addListener(() {
      performSearch(searchController.text);
    });
  }

  Future<void> fetchData() async {
    isLoading.value = true;

    user.value = userService.user.value;

    isLoading.value = false;
    update();
  }

  void updateLoadingState() {
    isLoading.value = !(user.value != null &&
        evaluations.isNotEmpty &&
        participants.isNotEmpty);
    update();
  }

  void addNewParticipant(ParticipantEntity newParticipant,
      Map<String, int> newParticipantMap, Language language) {
    var newParticipantID = newParticipantMap["participantId"];
    var newEvaluationID = newParticipantMap["evaluationId"];
    var evaluatorID = user.value!.evaluatorID;

    participants.add(newParticipant);
    participantDetails[newParticipantID!] = newParticipant;

    evaluations.add(EvaluationEntity(
      evaluatorID: evaluatorID!,
      evaluationID: newEvaluationID,
      participantID: newParticipantID,
      language: language.numericValue,
    ));

    refreshData();
  }

  Future<void> refreshData() async {
    isLoading.value = true;

    var updatedParticipants = await userService.fetchUpdatedParticipants();
    participants.assignAll(updatedParticipants);

    isLoading.value = false;
    update(); // Notify listeners to rebuild the UI
  }

  Future<void> handleDownload(
      int evaluationId, String evaluatorId, String participantId) async {
    // 1. Fetch all task instances related to the evaluation
    List<TaskInstanceEntity> taskInstances =
        await fetchTaskInstancesForEvaluation(evaluationId);

    // 2. Fetch all recordings for these task instances
    List<RecordingFileEntity> recordings = [];
    for (var taskInstance in taskInstances) {
      List<RecordingFileEntity> taskRecordings = await recordingRepository
          .getRecordingsByTaskInstanceId(taskInstance.taskInstanceID!);
      recordings.addAll(taskRecordings);
    }

    // 3. Create the folder in the downloads directory
    String downloadFolderPath =
        await createDownloadFolder(evaluatorId, participantId);

    // 4. Copy the audio files to the new folder
    // Decrypt files and rename them back to .aac
    for (var recording in recordings) {
      String encryptedFilePath = recording.filePath;
      String fileNameWithoutExtension =
          path.basenameWithoutExtension(encryptedFilePath);
      String decryptedFilePath =
          path.join(downloadFolderPath, fileNameWithoutExtension);

      // Decrypt the file back to its original form
      await fileEncryptor.decryptFile(encryptedFilePath, decryptedFilePath);

      print('Decrypted recording saved at path: $decryptedFilePath');
    }
  }

  Future<void> createDownload(EvaluationEntity evaluation) async {
    final downloadFolderPath = await createDownloadFolder(
        evaluation.evaluatorID.toString(), evaluation.participantID.toString());

    generateParticipantRecordFile(
        evaluation: evaluation, filePath: downloadFolderPath);
  }

  Future<List<TaskInstanceEntity>> fetchTaskInstancesForEvaluation(
      int evaluationId) async {
    List<TaskInstanceEntity> allTaskInstances = [];

    // Get Module Instances by Evaluation ID
    List<ModuleInstanceEntity> moduleInstances = await moduleInstanceRepository
        .getModuleInstancesByEvaluationId(evaluationId);

    // Get Task Instances for each Module Instance
    for (var moduleInstance in moduleInstances) {
      List<TaskInstanceEntity> taskInstances = await taskInstanceRepository
          .getTaskInstancesByModuleInstanceId(moduleInstance.moduleInstanceID!);
      allTaskInstances.addAll(taskInstances);
    }

    return allTaskInstances;
  }

  void filterEvaluationsByStatus() {
    if (selectedStatus.value != null) {
      filteredEvaluations.assignAll(
        evaluations
            .where((evaluation) => evaluation.status == selectedStatus.value)
            .toList(),
      );
    } else {
      filteredEvaluations.assignAll(evaluations);
    }
    update(); // This will update the UI if you are using Obx() or GetBuilder()
  }

  void generateParticipantRecordFile(
      {required EvaluationEntity evaluation, required String filePath}) {
    evalDataService.generateParticipantRecordFile(
        evaluation: evaluation, filePath: filePath);
  }

  void performSearch(String query) {
    if (query.isEmpty) {
      resetFilters();
    } else {
      // Apply search filter
      filteredEvaluations.assignAll(
        evaluations.where((evaluation) {
          final participant = participantDetails[evaluation.participantID];
          return participant?.name
                  .toLowerCase()
                  .contains(query.toLowerCase()) ??
              false;
        }).toList(),
      );
    }
    update();
  }

  void setEvaluationInProgress(int evaluationId) {
    var index =
        evaluations.indexWhere((eval) => eval.evaluationID == evaluationId);
    if (index != -1) {
      var evaluation = evaluations[index];
      evaluation.status = EvaluationStatus.in_progress;
      evaluations[index] = evaluation;
      evaluations.refresh();
    }
  }

  void refreshEvaluationCounts() {
    int inProgressCount = evaluations
        .where((e) => e.status == EvaluationStatus.in_progress)
        .length;
    int finishedCount =
        evaluations.where((e) => e.status == EvaluationStatus.completed).length;

    numEvaluationsInProgress.value = inProgressCount;
    numEvaluationsFinished.value = finishedCount;
  }

  void refreshEvaluations() async {
    isLoading.value = true;

    if (user.value != null) {
      await userService.fetchUserData(user.value!.evaluatorID);
      refreshEvaluationCounts();
    }
    isLoading.value = false;
    update();
  }
}
