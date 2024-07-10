import 'package:get/get.dart';
import '../../app/evaluator/evaluator_repository.dart';
import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
            () => LoginController(Get.find<EvaluatorRepository>())
    );
  }
}
