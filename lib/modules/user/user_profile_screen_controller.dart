import 'package:get/get.dart';

import '../../app/evaluation/evaluation_entity.dart';
import '../../app/evaluator/evaluator_entity.dart';
import '../../app/module_instance/module_instance_entity.dart';
import '../../global/typedefs.dart';
import '../../global/user_service.dart';

class UserProfileScreenController extends GetxController {
  final UserService userService = Get.find<UserService>();

  final Rx<EvaluatorEntity?> userAvaliador = Rx<EvaluatorEntity?>(null);
  RxList<EvaluationEntity> evaluations = <EvaluationEntity>[].obs;
  RxMap<int, List<ModuleInstanceEntity>> modules = <int, List<ModuleInstanceEntity>>{}.obs;
  Rx<EvaluationMap> evaluationMap = Rx<EvaluationMap>({});

  @override
  void onInit() {
    super.onInit();
    userAvaliador.value = userService.user.value;
    evaluations.value = userService.evaluations;
    modules.value = userService.modules;
    evaluationMap.value = userService.evaluationMap.value;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
