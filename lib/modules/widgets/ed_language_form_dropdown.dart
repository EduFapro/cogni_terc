import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/enums/language_enums.dart';
import '../participant_registration/participant_registration_controller.dart';

class EdLanguageFormDropdown extends GetView<ParticipantRegistrationController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var currentLanguage = controller.selectedLanguage.value ?? Language.portuguese;
      return DropdownButtonFormField<Language>(
        decoration: InputDecoration(
          labelText: 'Language', // Use your actual label here
          filled: true,
          fillColor: Color(0xffededed),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        value: currentLanguage,
        onChanged: (Language? newValue) {
          if (newValue != null) {
            controller.selectedLanguage.value = newValue;
          }
        },
        items: Language.values
            .where((language) => language != Language.english) // Exclude English
            .map<DropdownMenuItem<Language>>((language) {
          return DropdownMenuItem<Language>(
            value: language,
            child: Text(language.translationKey),
          );
        }).toList(),
      );
    });
  }
}
