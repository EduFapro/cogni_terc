import 'package:get/get.dart';

import '../../app/task/task_repository.dart';
import '../../app/task_instance/task_instance_repository.dart';
import '../../app/task_prompt/task_prompt_repository.dart';
import 'task_screen_controller.dart';
import 'task_screen_service.dart';

class TaskScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskScreenService>(
      () => TaskScreenService(
          taskPromptRepository: Get.find<TaskPromptRepository>(),
          taskInstanceRepository: Get.find<TaskInstanceRepository>(),
          taskRepository: Get.find<TaskRepository>()),
    );

    // Use fenix to recreate TaskController when needed
    Get.lazyPut<TaskScreenController>(
      () => TaskScreenController(taskService: Get.find()),
      fenix: true,
    );
  }
}
