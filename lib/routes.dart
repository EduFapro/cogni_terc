import 'package:get/get_navigation/src/routes/get_route.dart';

import 'modules/evaluation/evaluation_binding.dart';
import 'modules/evaluation/evaluation_screen.dart';
import 'modules/evaluator_registration/evaluator_registration_binding.dart';
import 'modules/evaluator_registration/evaluator_registration_screen.dart';
import 'modules/evaluators/evaluators_binding.dart';
import 'modules/evaluators/evaluators_screen.dart';
import 'modules/home/home_binding.dart';
import 'modules/home/home_screen.dart';
import 'modules/login/login_binding.dart';
import 'modules/login/login_screen.dart';
import 'modules/new_password/new_password_binding.dart';
import 'modules/new_password/new_password_screen.dart';
import 'modules/participant_registration/participant_registration_binding.dart';
import 'modules/participant_registration/participant_registration_screen.dart';
import 'modules/task_screen/task_binding.dart';
import 'modules/task_screen/task_screen.dart';
import 'modules/user/user_profile_screen.dart';
import 'modules/user/user_profile_screen_binding.dart';

class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const evaluatorRegistration = '/evaluatorRegistration';
  static const evaluators = '/evaluators';
  static const participantRegistration = '/participantRegistration';
  static const evaluation = '/module';
  static const task = '/task';
  static const newPassword = '/new_password';
  static const userProfileScreen = '/user_profile_screen';
}

final routes = [
  GetPage(
    name: AppRoutes.home,
    page: () => HomeScreen(),
    binding: HomeBinding(),
  ),
  GetPage(
    name: AppRoutes.evaluators,
    page: () => EvaluatorsScreen(),
    binding: EvaluatorsBinding(),
  ),
  GetPage(
    name: AppRoutes.evaluatorRegistration,
    page: () => EvaluatorRegistrationScreen(),
    binding: EvaluatorRegistrationBinding(),
  ),
  GetPage(
    name: AppRoutes.participantRegistration,
    page: () => ParticipantRegistrationScreen(),
    binding: ParticipantRegistrationBinding(),
  ),
  GetPage(
    name: AppRoutes.login,
    page: () => LoginScreen(),
    binding: LoginBinding(),
  ),
  GetPage(
    name: AppRoutes.evaluation,
    page: () => EvaluationScreen(),
    binding: EvaluationBinding(),
  ),
  GetPage(
    name: AppRoutes.task,
    page: () => TaskScreen(),
    binding: TaskScreenBinding(),
  ),
  GetPage(
    name: AppRoutes.newPassword,
    page: () => NewPasswordScreen(),
    binding: NewPasswordBinding(),
  ),
  GetPage(
    name: AppRoutes.userProfileScreen,
    page: () => UserProfileScreen(),
    binding: UserProfileScreenBinding(),
  ),
];
