import 'package:get/get.dart';

import 'dart:convert';
import 'dart:io';

import '../../app/evaluation/evaluation_entity.dart';
import '../../app/task_instance/task_instance_entity.dart';
import '../evaluation/evaluation_service.dart';
import 'package:path/path.dart' as path;

class EvalDataService {
  final evaluationService = Get.find<EvaluationService>();

  Future<void> generateParticipantRecordFile(
      {required EvaluationEntity evaluation, required String filePath}) async {
    print("generateParticipantRecordFile called");
    print("Calling evaluation service");

    var moduleInstances = await evaluationService
        .getModuleInstancesByEvaluationId(evaluation.evaluationID!);

    List<String> moduleNames =
        await Future.wait(moduleInstances.map((element) async {
      var module = await element.module;
      return module!.title!;
    }));

    Map<int, List<TaskInstanceEntity>> taskMaps = {};

    for (int i = 0; i < moduleInstances.length; i++) {
      var moduleInstId = moduleInstances[i].moduleInstanceID;
      var taskInstancesByModule = await evaluationService
          .getTaskInstancesByModuleInstanceId(moduleInstId!);
      taskMaps[moduleInstId] = taskInstancesByModule!;
    }

    var newParticipantRecordFile = ParticipantRecordFile(
        evaluation.evaluationID!,
        evaluation.evaluatorID,
        evaluation.participantID,
        moduleNames,
        taskMaps);

    print("newParticipantRecordFile: $newParticipantRecordFile");

    ParticipantRecordFile.generateJsonFile(newParticipantRecordFile, filePath);

  }
}

class ParticipantRecordFile {
  final int evaluationID;
  final int evaluatorID;
  final int participantID;
  final List<String> modules;
  final Map<int, List<TaskInstanceEntity>> taskMaps;

  ParticipantRecordFile(
    this.evaluationID,
    this.evaluatorID,
    this.participantID,
    this.modules,
    this.taskMaps,
  );

  Map<String, dynamic> toJson() {
    return {
      'evaluationID': evaluationID,
      'evaluatorID': evaluatorID,
      'participantID': participantID,
      'modules': modules,
      'taskMaps': taskMaps.map((key, value) =>
          MapEntry(key.toString(), value.map((e) => e.toJson()).toList())),
    };
  }

  static Future<void> generateJsonFile(ParticipantRecordFile participantRecordFile, String directoryPath) async {
    // Make sure the directory path is correct and points to a valid directory
    final String fileName = 'A${participantRecordFile.evaluatorID.toString().padLeft(2, '0')}P${participantRecordFile.participantID.toString().padLeft(2, '0')}.json';
    final String fullPath = path.join(directoryPath, fileName);
    final file = File(fullPath);

    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true); // Ensure the directory exists
    }

    final jsonStr = jsonEncode(participantRecordFile.toJson());
    await file.writeAsString(jsonStr);

    print('JSON file generated: ${file.path}');
  }



  @override
  String toString() {
    return 'ParticipantRecordFile{evaluationID: $evaluationID, evaluatorID: $evaluatorID, participantID: $participantID, modules: $modules, tasks: $taskMaps}';
  }
}
