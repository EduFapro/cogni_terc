import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/enums/language_enums.dart';
import '../../global/language_controller.dart';

class EdLanguageDropdown extends GetView<LanguageController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10), // Adjusts internal padding
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(10), // Rounded corners
        border: Border.all(color: Colors.grey.shade300), // Border color
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Language>(
          hint: Text(Language.portuguese.translationKey),
          value: controller.currentLanguage.value,
          onChanged: (Language? newValue) {
            if (newValue != null) {
              controller.changeLanguage(newValue);
            }
          },
          items: Language.values
              .map<DropdownMenuItem<Language>>((language) {
            return DropdownMenuItem<Language>(
              value: language,
              child: Text(language.translationKey),
            );
          }).toList(),
        ),
      ),
    );
  }
}
