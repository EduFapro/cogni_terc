import 'package:get/get.dart';

import 'evaluation_controller.dart';


class EvaluationBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy put EvaluationController into GetX storage, ensuring it can be retrieved later
    Get.lazyPut<EvaluationController>(
          () => EvaluationController(),
      fenix: true, // fenix: true will recreate the controller if it was ever disposed.
    );
  }
}
