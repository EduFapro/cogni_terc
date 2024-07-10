import 'package:get/get.dart';

import 'user_profile_screen_controller.dart';

class UserProfileScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserProfileScreenController(), permanent: true);
  }
}
