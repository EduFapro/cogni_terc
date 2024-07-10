import 'package:get/get.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register controller with all required repositories
    Get.lazyPut(() => HomeController());
  }
}
