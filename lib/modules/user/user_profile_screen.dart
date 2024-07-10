import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/evaluation/evaluation_entity.dart';
import '../../app/evaluator/evaluator_entity.dart';
import '../../app/module_instance/module_instance_entity.dart';
import '../../app/task_instance/task_instance_entity.dart';
import 'user_profile_screen_controller.dart';

class UserProfileScreen extends GetView<UserProfileScreenController> {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        centerTitle: false,
        backgroundColor: Colors.black,
      ),
      body: Obx(() {
        var userInfo = controller.userAvaliador.value;
        var evaluationMap = controller.evaluationMap.value;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Evaluator Information
              if (userInfo != null)
                UserInfoSection(userInfo: userInfo),

              // Evaluations and Module Instances
              for (var evaluationEntry in evaluationMap.entries)
                EvaluationSection(evaluation: evaluationEntry.key, moduleInstanceMap: evaluationEntry.value),
            ],
          ),
        );
      }),
    );
  }
}

class UserInfoSection extends StatelessWidget {
  final EvaluatorEntity userInfo;

  const UserInfoSection({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Evaluator: ${userInfo.name}"),
      children: [
        ListTile(
          title: Text("${userInfo.name} ${userInfo.surname}"),
          subtitle: Text("Username: ${userInfo.username}"),
          // Add more details as needed
        ),
      ],
    );
  }
}

class EvaluationSection extends StatelessWidget {
  final EvaluationEntity evaluation;
  final Map<ModuleInstanceEntity, List<TaskInstanceEntity>> moduleInstanceMap;

  const EvaluationSection({
    Key? key,
    required this.evaluation,
    required this.moduleInstanceMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Evaluation: ${evaluation.evaluationID}"),
      children: moduleInstanceMap.entries.map((moduleEntry) =>
          ModuleInstanceSection(
            moduleInstance: moduleEntry.key,
            taskInstances: moduleEntry.value,
          ),
      ).toList(),
    );
  }
}

class ModuleInstanceSection extends StatelessWidget {
  final ModuleInstanceEntity moduleInstance;
  final List<TaskInstanceEntity> taskInstances;

  const ModuleInstanceSection({
    Key? key,
    required this.moduleInstance,
    required this.taskInstances,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Module Instance: ${moduleInstance.moduleInstanceID}"),
      children: taskInstances.map((task) => ListTile(
        title: Text("Task ID: ${task.taskID} - ${task.status.description}"),
        trailing: Text("Duration: ${task.completingTime ?? 'Not completed'}"),
      )).toList(),
    );
  }
}
