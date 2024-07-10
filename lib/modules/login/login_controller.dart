import 'package:get/get.dart';

import '../../app/evaluator/evaluator_entity.dart';
import '../../app/evaluator/evaluator_repository.dart';
import '../../global/user_service.dart';

class LoginController extends GetxController {
  final EvaluatorRepository evaluatorRepository;

  var isLoading = false.obs;
  var loginError = RxString('');
  var currentEvaluator = Rx<EvaluatorEntity?>(null);
  var currentEvaluatorFirstLogin = RxBool(false);
  var userService = Get.find<UserService>();

  LoginController(this.evaluatorRepository);

  Future<bool> login(String username, String password) async {
    isLoading.value = true;
    loginError.value = '';
    try {
      EvaluatorEntity? user = await evaluatorRepository.getEvaluatorByUsername(username);

      if (user != null) {
        if (user.password == password) {
          currentEvaluator.value = user;
          currentEvaluatorFirstLogin.value = user.firstLogin;
          userService.updateUser(user);
          isLoading.value = false;
          return true;
        } else {
          loginError.value = "Invalid username or password";
        }
      } else {
        loginError.value = "User not found. Please check your username and try again.";
      }
    } catch (e) {
      loginError.value = "Login failed, please try again later";
    }

    isLoading.value = false;
    return false;
  }

  @override
  void onInit() {
    super.onInit();
  }
}
