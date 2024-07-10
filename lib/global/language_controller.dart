import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/enums/language_enums.dart';

class LanguageController extends GetxController {
  var currentLanguage = Language.portuguese.obs;

  void changeLanguage(Language language) {
    currentLanguage.value = language;
    Locale locale;
    switch (language) {
      case Language.english:
        locale = Locale('en', 'US');
        break;
      case Language.spanish:
        locale = Locale('es', 'ES');
        break;
      default:
        locale = Locale('pt', 'BR');
    }
    Get.updateLocale(locale);
  }
}
