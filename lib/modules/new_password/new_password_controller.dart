import 'package:get/get.dart';


import '../../app/evaluator/evaluator_entity.dart';
import '../../app/evaluator/evaluator_repository.dart';
import '../../constants/route_arguments.dart';

class NewPasswordController extends GetxController {
  late bool isFirstLogin;
  late EvaluatorEntity evaluator;

  final EvaluatorRepository evaluatorRepository;

  NewPasswordController({required this.evaluatorRepository});

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    isFirstLogin = arguments[RouteArguments.FIRST_LOGIN];
    evaluator = arguments[RouteArguments.EVALUATOR];
  }

  Future<void> changePassword(String newPassword) async {
    var fetchedEvaluator = await evaluatorRepository.getEvaluator(evaluator.evaluatorID!);
    if (fetchedEvaluator != null) {
      fetchedEvaluator.password = newPassword;
      fetchedEvaluator.firstLogin = false;

      await evaluatorRepository.updateEvaluator(fetchedEvaluator);
    }
  }
}
