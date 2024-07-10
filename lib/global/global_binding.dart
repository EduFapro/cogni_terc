import 'package:encrypt/encrypt.dart';
import 'package:get/get.dart';
import '../app/participant/participant_local_datasource.dart';
import '../app/recording_file/recording_file_datasource.dart';
import '../app/task_instance/task_instance_local_datasource.dart';
import '../app/participant/participant_repository.dart';
import '../app/recording_file/recording_file_repository.dart';
import '../app/task/task_local_datasource.dart';
import '../app/task_instance/task_instance_repository.dart';
import '../app/task/task_repository.dart';
import '../app/task_prompt/task_prompt_local_datasource.dart';
import '../app/task_prompt/task_prompt_repository.dart';
import '../app/evaluation/evaluation_local_datasource.dart';
import '../app/evaluation/evaluation_repository.dart';
import '../app/evaluator/evaluator_local_datasource.dart';
import '../app/evaluator/evaluator_repository.dart';
import '../app/module/module_local_datasource.dart';
import '../app/module/module_repository.dart';
import '../app/module_instance/module_instance_local_datasource.dart';
import '../app/module_instance/module_instance_repository.dart';
import '../file_management/file_encryptor.dart';
import '../modules/eval_data/eval_data_service.dart';
import '../modules/evaluation/evaluation_service.dart';
import 'language_controller.dart';
import 'user_service.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // Data Sources and Repositories

    // Evaluator
    Get.lazyPut<EvaluatorLocalDataSource>(() => EvaluatorLocalDataSource(),
        fenix: true);
    Get.lazyPut<EvaluatorRepository>(
        () => EvaluatorRepository(localDataSource: Get.find()),
        fenix: true);

    // Evaluation
    Get.lazyPut<EvaluationLocalDataSource>(() => EvaluationLocalDataSource(),
        fenix: true);
    Get.lazyPut<EvaluationRepository>(
        () => EvaluationRepository(localDataSource: Get.find()),
        fenix: true);

    // Participant
    Get.lazyPut<ParticipantLocalDataSource>(() => ParticipantLocalDataSource(),
        fenix: true);
    Get.lazyPut<ParticipantRepository>(
        () => ParticipantRepository(localDataSource: Get.find()),
        fenix: true);

    // Module and Task
    Get.lazyPut<ModuleLocalDataSource>(() => ModuleLocalDataSource(),
        fenix: true);
    Get.lazyPut<TaskLocalDataSource>(() => TaskLocalDataSource(), fenix: true);
    Get.lazyPut<RecordingLocalDataSource>(() => RecordingLocalDataSource(),
        fenix: true);
    Get.lazyPut<ModuleRepository>(
        () => ModuleRepository(
            moduleLocalDataSource: Get.find(), taskLocalDataSource: Get.find()),
        fenix: true);
    Get.lazyPut<TaskRepository>(
        () => TaskRepository(localDataSource: Get.find()),
        fenix: true);
    Get.lazyPut<RecordingRepository>(
        () => RecordingRepository(Get.find<RecordingLocalDataSource>()),
        fenix: true);

    // Module Instance
    Get.lazyPut<ModuleInstanceLocalDataSource>(
        () => ModuleInstanceLocalDataSource(),
        fenix: true);
    Get.lazyPut<ModuleInstanceRepository>(
        () =>
            ModuleInstanceRepository(moduleInstanceLocalDataSource: Get.find()),
        fenix: true);

    // Task Instance
    Get.lazyPut<TaskInstanceLocalDataSource>(
        () => TaskInstanceLocalDataSource(),
        fenix: true);
    Get.lazyPut<TaskInstanceRepository>(
        () => TaskInstanceRepository(localDataSource: Get.find()),
        fenix: true);

    // Task Prompt
    Get.lazyPut<TaskPromptLocalDataSource>(() => TaskPromptLocalDataSource(),
        fenix: true);
    Get.lazyPut<TaskPromptRepository>(
        () => TaskPromptRepository(localDataSource: Get.find()),
        fenix: true);

    // Core Services
    // User-related Services
    Get.put<UserService>(UserService(), permanent: true);
    Get.put(LanguageController());
    Get.put(EvaluationService(
        moduleRepository: Get.find(),
        taskRepository: Get.find(),
        moduleInstanceRepository: Get.find(),
        taskInstanceRepository: Get.find(),
        evaluationRepository: Get.find()));
    Get.put<EvalDataService>(EvalDataService(), permanent: true);

    final key =
        Key.fromUtf8('12345678901234567890123456789012'); // 32 bytes key
    final iv = IV.fromLength(16); // AES block size is 16 bytes

    final fileEncryptor = FileEncryptor(key, iv);

    Get.put<FileEncryptor>(fileEncryptor, permanent: true);
  }
}
