import 'package:get/get.dart';

import 'en_us_translations.dart';
import 'es_es_translations.dart';
import 'pt_br_translations.dart';

class UiStrings extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUsTranslations,
        'pt_BR': ptBrTranslations,
        'es_ES': esEsTranslations
      };

  static String get hello => 'hello'.tr;

  static String get newParticipant => 'new_participant'.tr;

  static String get password => 'password'.tr;

  static String get login => 'login'.tr;

  static String get username => 'username'.tr;

  static String get home => 'home'.tr;

  static String get evaluators => 'evaluators'.tr;

  static String get totalProjects => 'total_projects'.tr;

  static String get inProgress => 'in_progress'.tr;

  static String get completed => 'completed'.tr;

  static String get evaluationHistory => 'evaluation_history'.tr;

  static String get name => 'name'.tr;

  static String get status => 'status'.tr;

  static String get evaluator => 'evaluator'.tr;

  static String get date => 'date'.tr;

  static String get participantRegistration => 'participant_registration'.tr;

  static String get identificationData => 'identification_data'.tr;

  static String get fullName => 'full_name'.tr;

  static String get dateOfBirth => 'date_of_birth'.tr;

  static String get sex => 'sex'.tr;

  static String get educationLevel => 'education_level'.tr;

  static String get laterality => 'laterality'.tr;

  static String get modules => 'modules'.tr;

  static String get language => 'language'.tr;

  static String get selectedModules => 'selected_modules'.tr;

  static String get register => 'register'.tr;

  static String get cancel => 'cancel'.tr;

  static String get evaluatorsList => 'evaluators_list'.tr;

  static String get newEvaluator => 'new_evaluator'.tr;

  static String get evaluatorRegistration => 'evaluator_registration'.tr;

  static String get specialty => 'specialty'.tr;

  static String get cpf => 'cpf'.tr;

  static String get evaluation => 'evaluation'.tr;

  static String get listOfActivities => 'list_of_activities'.tr;

  static String get clickOnPlayToListenToTheTask =>
      'click_on_play_to_listen_to_audio'.tr;

  static String get pendingEvaluation => 'pending_evaluation'.tr;

  static String get inProgressEvaluation => 'in_progress_evaluation'.tr;

  static String get completedEvaluation => 'completed_evaluation'.tr;

  static String get portugueseLanguage => 'portuguese_language'.tr;

  static String get selectLanguage => 'select_language'.tr;

  static String get spanishLanguage => 'spanish_language'.tr;

  static String get englishLanguage => 'english_language'.tr;

  static String get femaleSex => 'female_sex'.tr;

  static String get maleSex => 'male_sex'.tr;

  static String get pendingModule => 'pending_module'.tr;

  static String get inProgressModule => 'in_progress_module'.tr;

  static String get completedModule => 'completed_module'.tr;

  static String get pendingTask => 'pending_task'.tr;

  static String get doneTask => 'done_task'.tr;

  static String get playMode => 'play_mode'.tr;

  static String get recordMode => 'record_mode'.tr;

  static String get start_task_button => 'start_task_button'.tr;
}
