import 'package:get/get.dart';

import '../../app/participant/participant_repository.dart';
import '../../app/task_instance/task_instance_repository.dart';
import '../../app/task/task_repository.dart';
import '../../app/evaluation/evaluation_repository.dart';
import '../../app/module/module_repository.dart';
import '../../app/module_instance/module_instance_repository.dart';
import 'participant_registration_controller.dart';
import 'participant_registration_service.dart';

class ParticipantRegistrationBinding extends Bindings {
  @override
  void dependencies() {


    // Register service
    Get.lazyPut<ParticipantRegistrationService>(
            () => ParticipantRegistrationService(
          moduleInstanceRepository: Get.find<ModuleInstanceRepository>(),
          participantRepository: Get.find<ParticipantRepository>(),
          evaluationRepository: Get.find<EvaluationRepository>(),
          moduleRepository: Get.find<ModuleRepository>(),
          taskRepository: Get.find<TaskRepository>(),
          taskInstanceRepository: Get.find<TaskInstanceRepository>(),
        ));

    // Register controller with the service
    Get.lazyPut<ParticipantRegistrationController>(() =>
        ParticipantRegistrationController(
            Get.find<ParticipantRegistrationService>()));
  }
}
