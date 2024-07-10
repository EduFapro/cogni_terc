import 'package:get/get.dart';
import 'evaluators_controller.dart';

class EvaluatorsBinding extends Bindings {
  @override
  void dependencies() {

    Get.put(EvaluatorsController(), permanent: true);


  }
}
