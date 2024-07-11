import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as path;
import '../../app/evaluation/evaluation_entity.dart';
import '../../app/evaluation/evaluation_repository.dart';
import '../../app/evaluator/evaluator_entity.dart';
import '../../app/module_instance/module_instance_entity.dart';
import '../../app/participant/participant_entity.dart';
import '../../app/recording_file/recording_file_entity.dart';
import '../../app/recording_file/recording_file_repository.dart';
import '../../app/task/task_entity.dart';
import '../../app/task_instance/task_instance_entity.dart';
import '../../app/task_instance/task_instance_repository.dart';
import '../../constants/enums/module_enums.dart';
import '../../constants/enums/task_enums.dart';
import '../../constants/route_arguments.dart';
import '../../file_management/audio_management.dart';
import '../evaluation/evaluation_controller.dart';
import '../evaluation/evaluation_service.dart';
import '../home/home_controller.dart';
import 'task_screen_service.dart';

class TaskScreenController extends GetxController {
  final EvaluationService evaluationService = Get.find();

  final TaskScreenService taskService;
  late final AudioPlayer _audioPlayer;
  late final AudioRecorder _recorder;

  var participant = Rxn<ParticipantEntity>();
  var evaluation = Rxn<EvaluationEntity>();
  var evaluator = Rxn<EvaluatorEntity>();
  var taskName = RxString("");
  var task = Rxn<TaskEntity>();
  var taskInstance = Rxn<TaskInstanceEntity>();
  var moduleInstance = Rxn<ModuleInstanceEntity>();

  var audioPath = ''.obs;
  var currentTask = Rx<TaskInstanceEntity?>(null);
  var taskMode = Rx<TaskMode>(TaskMode.record);
  var currentTaskEntity = Rx<TaskEntity?>(null);
  var countdownStarted = false.obs;
  var countdownTrigger = false.obs;
  var currentTaskIndex = 1.obs;
  var totalTasks = 1.obs;
  var isModuleCompleted = false.obs;

  var isPlaying = false.obs;
  var audioPlayed = false.obs;
  var isRecording = false.obs;
  var recordingDone = false.obs;
  var isCheckButtonEnabled = false.obs;
  var isRecordButtonEnabled = false.obs;

  // Inside TaskScreenController
  RxBool get shouldDisablePlayButton => RxBool(!mayRepeatPrompt.value && promptPlayedOnce.value || isRecording.value);


  var mayRepeatPrompt = false.obs;
  var promptPlayedOnce = false.obs;

  var recordingRepository = Get.find<RecordingRepository>();
  var evaluationRepository = Get.find<EvaluationRepository>();
  var taskInstanceRepository = Get.find<TaskInstanceRepository>();

  DateTime? _audioStopTime;
  DateTime? _buttonClickTime;

  TaskScreenController({required this.taskService});

  Future<void> refreshProgress() async {
    final taskInstances =
        await taskInstanceRepository.getTaskInstancesByModuleInstanceId(
            moduleInstance.value!.moduleInstanceID!);
    final completedTasksCount = taskInstances
        .where((taskInst) => taskInst.status == TaskStatus.done)
        .length;
    currentTaskIndex.value = completedTasksCount + 1;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    _audioPlayer = AudioPlayer();
    _recorder = AudioRecorder();

    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      participant.value = arguments[RouteArguments.PARTICIPANT];
      evaluation.value = arguments[RouteArguments.EVALUATION];
      evaluator.value = arguments[RouteArguments.EVALUATOR];

      taskName.value = arguments[RouteArguments.TASK_NAME];
      task.value = arguments[RouteArguments.TASK];
      mayRepeatPrompt.value = task.value!.mayRepeatPrompt;

      taskInstance.value = arguments[RouteArguments.TASK_INSTANCE];

      moduleInstance.value = arguments[RouteArguments.MODULE_INSTANCE];
      if (moduleInstance.value!.moduleInstanceID! != null) {
        // Calculate total tasks for the module instance.
        await _calculateTotalTasks(moduleInstance.value!.moduleInstanceID!);
      } else {
        // Fallback or error handling if moduleInstanceId is not provided.
        print("Module instance ID not found in arguments.");
      }
    }
    // Update the current task based on the task instance ID passed in the arguments.
    if (taskInstance.value != null) {
      await updateCurrentTask(taskInstance.value!.taskInstanceID!);
    } else {
      // Fallback or error handling if task instance ID is not provided.
      print("Task instance ID not found in arguments.");
    }

    _audioPlayer.onPlayerComplete.listen((_) {
      isPlaying.value = false;
      audioPlayed.value = true;
      promptPlayedOnce.value = true;

      // Enable buttons as needed after audio completion
      updateButtonStatesAfterAudioCompletion();

      // Trigger countdown as audio has finished playing
      countdownTrigger.value = true; // This will start the countdown
    });

    taskMode.listen((mode) {
      print("Task mode changed to: $mode");
    });

    refreshProgress();
  }

  // Function to proceed to the next task
  void nextTask() {
    if (currentTaskIndex.value < totalTasks.value - 1) {
      currentTaskIndex.value++;
      // Load the next task or handle it accordingly
    }
  }

  Future<Uint8List> loadAudioAsset(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  void startCountdown() {
    countdownStarted.value = true;

    // Simulate countdown using Future.delayed
    Future.delayed(Duration(seconds: 5), () {
      // Countdown completed
      isCheckButtonEnabled.value = true;
    });
  }

  Future<void> updateCurrentTask(int taskInstanceId) async {
    try {
      var taskInstance = await taskService.getTaskInstance(taskInstanceId);
      if (taskInstance != null) {
        currentTask.value = taskInstance;
        var taskEntity = await taskService.getTask(taskInstance.taskID);
        currentTaskEntity.value = taskEntity;

        // Update mayRepeatPrompt based on the current task's properties
        mayRepeatPrompt.value = taskEntity?.mayRepeatPrompt ?? false;

        // Determine the task mode
        taskMode.value = taskEntity?.taskMode ?? TaskMode.play;

        // Reset states for the new task
        isCheckButtonEnabled.value = false;
        isRecordButtonEnabled.value = false;
        audioPlayed.value = false;
        countdownStarted.value = false;
        countdownTrigger.value = false;
        promptPlayedOnce.value = false;

        var taskPrompt = await taskService
            .getTaskPromptByTaskInstanceID(taskInstance.taskID);
        audioPath.value =
            taskPrompt?.filePath ?? 'assets/audio/audio_placeholder.mp3';
        checkAndDisablePlayButton();
      }
    } catch (e) {
      print("Error updating current task: $e");
    }
    isRecordButtonEnabled.value = false;
    isCheckButtonEnabled.value = false;
    audioPlayed.value = false;
    recordingDone.value = false;
  }

  Future<void> togglePlay() async {
    if (!isPlaying.value) {
      await play();
    } else {
      await stop();
    }
  }

  Future<void> play() async {
    try {
      final Uint8List audioBytes = await loadAudioAsset(audioPath.value);
      final BytesSource bytesSource = BytesSource(audioBytes);
      await _audioPlayer.play(bytesSource);
      isPlaying.value = true;
      isRecordButtonEnabled.value = false; // Disable recording when audio starts playing

      // Listen for audio completion
      _audioPlayer.onPlayerComplete.listen((_) {
        isPlaying.value = false;
        // Only enable recording if all conditions for recording are met
        if (shouldEnableRecording()) {
          isRecordButtonEnabled.value = true;
        }
      });
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    isPlaying.value = false;
    audioPlayed.value = true;
    _audioStopTime = DateTime.now();

    // Start countdown after audio stops
    countdownTrigger.value = true;
  }

  Future<void> startRecording() async {
    shouldDisablePlayButton.value = true;
    bool hasPermission = await _recorder.hasPermission();
    if (hasPermission) {
      String recordingPath = await _getRecordingPath();
      var config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      );
      await _recorder.start(config, path: recordingPath);
      isRecording.value = true;

      // isRecordButtonEnabled.value = false;
    } else {
      // Handle permission not granted
    }
  }

  Future<void> stopRecording() async {
    final String? originalPath = await _recorder.stop();
    isRecording.value = false;

    if (originalPath != null) {
      recordingDone.value = true;

      final evaluationController = Get.find<EvaluationController>();
      final evaluatorID = evaluationController.evaluation.value?.evaluatorID ?? 0;
      final participantID = evaluationController.participant.value?.participantID ?? 0;
      countdownTrigger.value = false; 

      // Encrypt the recording, rename it and save the new path
      final encryptedFilePath = await renameAndSaveRecording(
        originalPath: originalPath,
        evaluatorId: evaluatorID,
        participantId: participantID,
        taskEntityId: currentTaskEntity.value!.taskID!,
        taskInstanceId: currentTask.value!.taskInstanceID!,
        saveRecordingCallback: (RecordingFileEntity recording) async {
          final recordingId = await recordingRepository.createRecording(recording);
          print('Recording saved with ID: $recordingId at path: $recording.filePath');
        },
      );

      // Update the observable path with the encrypted file's path
      audioPath.value = encryptedFilePath;

      // In TaskMode.record, enable check button if audio has been played.
      if (taskMode.value == TaskMode.record && audioPlayed.value) {
        isCheckButtonEnabled.value = true;
      }
    } else {
      print('Recording was not stopped properly or path was null');
    }
    shouldDisablePlayButton.value = false;
  }


  // Future<void> saveAudio(ByteData data) async {
  //   print('saveAudio called');
  //   var evaluationController = Get.find<EvaluationController>();
  //   var evaluatorID = evaluationController.evaluation.value?.evaluatorID;
  //   var participantID = evaluationController.participant.value?.participantID;
  //
  //   if (evaluatorID != null && participantID != null) {
  //     print(
  //         'Saving audio for evaluator: $evaluatorID, participant: $participantID');
  //     // Create a unique file name for the temporary file
  //     final tempFileName = 'temp_recording.aac';
  //
  //     // Save the temporary file
  //     String tempPath = await saveAudioFile(data, tempFileName, evaluatorID,
  //         participantID, currentTask.value!.taskInstanceID!);
  //
  //     // Update audioPath to the new path
  //     audioPath.value = tempPath;
  //   } else {
  //     print('Evaluator ID or Participant ID is null');
  //     // Handle the null case, perhaps by using a default name or notifying the user
  //   }
  // }

  Future<String> _getRecordingPath() async {
    // Obtain the directory path for the application's documents directory.
    final String dirPath = await getApplicationDocumentsPath();

    // Create a Directory object using the documents directory path and appending the 'Cognivoice' subdirectory.
    final Directory mySubDir = Directory(path.join(dirPath, 'Cognivoice'));

    // Check if the 'Cognivoice' directory exists, and if not, create it recursively.
    if (!await mySubDir.exists()) {
      await mySubDir.create(recursive: true);
    }

    // Generate a timestamp string based on the current date and time for use in the file name.
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    // Construct a file name using the evaluator and participant ID, along with the timestamp, to ensure uniqueness.
    final String fileName = 'recording_$timestamp.aac';

    // Use the path package's join method to concatenate the directory path and file name,
    // ensuring the correct path separators are used for the platform.
    final String filePath = path.join(mySubDir.path, fileName);

    // Return the full file path where the recording will be saved.
    return filePath;
  }

  Future<void> onCheckButtonPressed() async {
    // Ensure there is a current task to conclude
    if (currentTask.value != null) {
      await concludeTaskInstance(currentTask.value!.taskInstanceID!);

      if (currentTaskIndex.value < totalTasks.value) {
        currentTaskIndex.value++; // Move to the next task

        // Attempt to fetch the next pending task instance
        var nextTaskInstance =
            await evaluationService.getNextPendingTaskInstanceForModule(
                moduleInstance.value!.moduleInstanceID!);
        if (nextTaskInstance != null) {
          // If there's a next task, update current task to this new task
          await updateCurrentTask(nextTaskInstance.taskInstanceID!);
        } else {
          // If there are no more tasks, mark the module as completed
          isModuleCompleted.value = true;
          await setModuleInstanceAsCompleted(
              moduleInstance.value!.moduleInstanceID!);
        }
      } else {
        // If we've reached or passed the last task, mark the module as completed
        isModuleCompleted.value = true;
        await setModuleInstanceAsCompleted(
            moduleInstance.value!.moduleInstanceID!);
      }
    } else {
      // If for some reason there's no current task, log an error or handle it
      print("Error: No current task found.");
    }
  }

  Future<void> concludeTaskInstance(int taskInstanceId) async {
    try {
      TaskInstanceEntity? taskInstance =
          await taskService.getTaskInstance(taskInstanceId);
      if (taskInstance != null) {
        taskInstance.status = TaskStatus.done;
        if (_audioStopTime != null) {
          final duration = DateTime.now().difference(_audioStopTime!);
          taskInstance.completeTask(duration);
        }
        bool updated = await taskService.updateTaskInstance(taskInstance);
        if (!updated) {
          print('Error updating task instance');
        }
      } else {
        print('Task instance not found');
      }
    } catch (e) {
      print('Error in concludeTaskInstance: $e');
    }
  }

  void completeTask(TaskInstanceEntity taskInstance) async {
    // Logic to mark the task as completed.
    taskInstance.completeTask(Duration.zero);
    await taskService.updateTaskInstance(taskInstance);

    // Assuming that the position in TaskEntity is the order of the task.
    final currentTaskEntity = await taskService.getTask(taskInstance.taskID);
    if (currentTaskEntity != null) {
      currentTaskIndex.value = currentTaskEntity.position;
    }
    // Load the next task or conclude if all tasks are completed.
  }

  Future<void> launchNextTask() async {
    if (currentTaskIndex.value >= totalTasks.value) {
      // All tasks are completed
      isModuleCompleted.value = true;
    } else if (currentTask.value != null &&
        currentTaskIndex.value < totalTasks.value) {
      await concludeTaskInstance(currentTask.value!.taskInstanceID!);

      // Fetch the next pending task instance
      final nextTaskInstance =
          await evaluationService.getNextPendingTaskInstanceForModule(
              moduleInstance.value!.moduleInstanceID!);
      if (nextTaskInstance != null) {
        // Update the current task
        currentTask.value = nextTaskInstance;
        // Fetch task entity for the next task
        var taskEntity = await taskService.getTask(nextTaskInstance.taskID);
        if (taskEntity != null) {
          currentTaskEntity.value = taskEntity;
          taskMode.value = taskEntity.taskMode;

          // Fetch and set the audio path for the next task
          var taskPrompt = await taskService
              .getTaskPromptByTaskInstanceID(nextTaskInstance.taskID);
          audioPath.value =
              taskPrompt?.filePath ?? 'assets/audio/audio_placeholder.mp3';

          // Reset audio player and recording states
          audioPlayed.value = false;
          isPlaying.value = false;
          if (isRecording.value) {
            await stopRecording();
          }
        }
      } else {
        isModuleCompleted.value = true;
      }
    }
  }

  void checkAndDisablePlayButton() {
    shouldDisablePlayButton.value =
        !mayRepeatPrompt.value && promptPlayedOnce.value;
  }

  void resetProgress() {
    currentTaskIndex.value = 0;
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    _recorder.dispose();
    super.onClose();
  }

  Future<void> _calculateTotalTasks(int moduleInstanceId) async {
    final taskInstances =
        await taskService.getTasksByModuleInstanceId(moduleInstanceId);
    totalTasks.value = taskInstances.length;
  }

  Future<void> setModuleInstanceAsCompleted(int moduleInstanceId) async {
    await evaluationService.setModuleInstanceAsCompleted(moduleInstanceId);
    var evaluationID =
    Get.find<EvaluationController>().evaluation.value!.evaluationID!;
    bool allModulesCompleted =
    await evaluationService.areAllModulesCompleted(evaluationID);
    if (allModulesCompleted) {
      print("All modules completed. Evaluation can be marked as completed.");
      evaluationRepository.setEvaluationAsCompleted(evaluationID);
      Get.find<HomeController>().refreshEvaluations();
      Get.find<HomeController>().refreshEvaluationCounts();
      Get.find<EvaluationController>().refreshModuleCompletionStatus(
          moduleInstanceId, ModuleStatus.completed);
    }
  }

  // TaskScreenController
  Future<void> skipCurrentTask() async {
    if (currentTask.value != null) {

      // Stop playing audio if it is currently playing
      if (isPlaying.value) {
        await stop(); // Assuming stop() is your method to stop audio playback
      }

      // Stop recording if it is currently active
      if (isRecording.value) {
        await stopRecording(); // Assuming stopRecording() is your method to stop recording
      }

      await concludeTaskInstance(currentTask.value!.taskInstanceID!);

      if (currentTaskIndex.value < totalTasks.value) {
        currentTaskIndex.value++; // Move to the next task

        // Attempt to fetch the next pending task instance
        var nextTaskInstance =
        await evaluationService.getNextPendingTaskInstanceForModule(
            moduleInstance.value!.moduleInstanceID!);
        if (nextTaskInstance != null) {
          // If there's a next task, update current task to this new task
          await updateCurrentTask(nextTaskInstance.taskInstanceID!);
        } else {
          // If there are no more tasks, mark the module as completed
          isModuleCompleted.value = true;
          await setModuleInstanceAsCompleted(
              moduleInstance.value!.moduleInstanceID!);
        }
      } else {
        // If we've reached or passed the last task, mark the module as completed
        isModuleCompleted.value = true;
        await setModuleInstanceAsCompleted(
            moduleInstance.value!.moduleInstanceID!);
      }
    } else {
      // If for some reason there's no current task, log an error or handle it
      print("Error: No current task found.");
    }
  }


  void manageButtonStates(
      {required bool isAudioPlaying, required bool isAudioCompleted}) {
    if (isAudioPlaying) {
      // Disable the check button while audio is playing
      isCheckButtonEnabled.value = false;
    }

    if (isAudioCompleted) {
      startCountdown();
    }
  }

  bool shouldEnableRecording() {
    // Add your conditions here. Example:
    return taskMode.value == TaskMode.record && !isPlaying.value && promptPlayedOnce.value;
  }

  void updateButtonStatesAfterAudioCompletion() {
    // Check button should be enabled only if no recording is needed or after recording is completed.
    // In TaskMode.play, enable if audio has played. In TaskMode.record, defer until recording is done.
    if (taskMode.value == TaskMode.play) {
      isCheckButtonEnabled.value = true;
    } else if (taskMode.value == TaskMode.record && recordingDone.value) {
      isCheckButtonEnabled.value = true;
    }

    // Ensure record button is enabled only in record mode and after audio playback.
    if (taskMode.value == TaskMode.record) {
      isRecordButtonEnabled.value = true;
    }
  }

}
