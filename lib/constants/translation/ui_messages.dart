import 'package:get/get.dart';

import 'en_us_translations.dart';
import 'es_es_translations.dart';
import 'pt_br_translations.dart';

class UiMessages extends Translations {

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUsTranslations,
    'pt_BR': ptBrTranslations,
    'es_ES': esEsTranslations
  };

  static String get cpfAlreadyInUse => 'cpf_already_in_use'.tr;
  static String get taskCompleted => 'task_completed'.tr;
  static String get allTasksCompleted => "all_tasks_completed".tr;
  static String get allTasksCompletedInModule => "all_tasks_completed_in_module".tr;
}
