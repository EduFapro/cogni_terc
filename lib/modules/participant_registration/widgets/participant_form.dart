import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/enums/person_enums/person_enums.dart';
import '../../../constants/translation/ui_strings.dart';
import '../../home/home_controller.dart';
import '../../login/login_controller.dart';
import '../../widgets/ed_language_form_dropdown.dart';
import '../participant_registration_controller.dart';

class ParticipantForm extends GetView<ParticipantRegistrationController> {
  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();
    var evaluator = loginController.currentEvaluator.value!;
    double screenWidth = MediaQuery.of(context).size.width;
    double formWidth = screenWidth * 0.8;
    const double spacingWidth = 16.0;
    double adjustedFormWidth = formWidth - spacingWidth;
    double adjustedFormWidthRow2 = formWidth - 2 * spacingWidth;

    double fieldWidthRow1 = adjustedFormWidth / 2;
    double fieldWidthRow2 = adjustedFormWidthRow2 / 3;
    var fieldContainerHeight = 80.0;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              UiStrings.identificationData,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        // SizedBox(
                        //   width: fieldWidthRow1,
                        //   child: TextFormField(
                        //     controller: controller.fullNameController,
                        //     decoration: InputDecoration(
                        //       filled: true,
                        //       fillColor: Color(0xffededed),
                        //       border: InputBorder.none,
                        //       labelText: UiStrings.fullName,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: fieldContainerHeight,
                          width: fieldWidthRow1,
                          child: TextFormField(
                            controller: controller.fullNameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xffededed),
                              labelText: UiStrings.fullName,
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'This field cannot be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: spacingWidth),
                        SizedBox(
                          height: fieldContainerHeight,
                          width: fieldWidthRow1,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a date'; // Return a message to show as an error
                              }
                              return null; // Return null if the date is valid
                            },
                            controller: controller.birthDateController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xffededed),
                              labelText: UiStrings.dateOfBirth,
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2.0),
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                controller.birthDateController.text = pickedDate
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0];
                                controller.selectedDate.value = pickedDate;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        SizedBox(
                          height: fieldContainerHeight,
                          width: fieldWidthRow2,
                          child: DropdownButtonFormField<Sex>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xffededed),
                              labelText: UiStrings.sex,
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2.0),
                              ),
                            ),
                            items: Sex.values.map((sex) {
                              return DropdownMenuItem<Sex>(
                                value: sex,
                                child: Text(sex.description),
                              );
                            }).toList(),
                            onChanged: (Sex? value) {
                              controller.selectedSex.value = value;
                            },
                            value: controller.selectedSex.value,
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an option'; // Error message
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: spacingWidth),
                        SizedBox(
                          height: fieldContainerHeight,
                          width: fieldWidthRow2,
                          child: DropdownButtonFormField<EducationLevel>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xffededed),
                              labelText: UiStrings.educationLevel,
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2.0),
                              ),
                            ),
                            items: EducationLevel.values.map((educationLevel) {
                              return DropdownMenuItem<EducationLevel>(
                                value: educationLevel,
                                child: Text(educationLevel.description),
                              );
                            }).toList(),
                            onChanged: (EducationLevel? value) {
                              controller.selectedEducationLevel.value = value;
                            },
                            value: controller.selectedEducationLevel.value,
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an option'; // Error message
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: spacingWidth),
                        // SizedBox(
                        //   height: fieldContainerHeight,
                        //   width: fieldWidthRow2,
                        //   child: DropdownButtonFormField<Handedness>(
                        //     decoration: InputDecoration(
                        //       filled: true,
                        //       fillColor: Color(0xffededed),
                        //       labelText: UiStrings.laterality,
                        //       errorBorder: OutlineInputBorder(
                        //         borderSide:
                        //             BorderSide(color: Colors.red, width: 1.0),
                        //       ),
                        //       focusedErrorBorder: OutlineInputBorder(
                        //         borderSide:
                        //             BorderSide(color: Colors.red, width: 2.0),
                        //       ),
                        //     ),
                        //     items: Handedness.values.map((handedness) {
                        //       return DropdownMenuItem<Handedness>(
                        //         value: handedness,
                        //         child: Text(handedness.description),
                        //       );
                        //     }).toList(),
                        //     onChanged: (Handedness? value) {
                        //       controller.selectedLaterality.value = value;
                        //     },
                        //     value: controller.selectedLaterality.value,
                        //     validator: (value) {
                        //       if (value == null) {
                        //         return 'Please select an option'; // Error message
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Text(
              UiStrings.modules,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Form(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: spacingWidth),
                        SizedBox(
                          width: fieldWidthRow1,
                          child: EdLanguageFormDropdown(),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.0),
                    Padding(
                      padding: EdgeInsets.only(left: spacingWidth),
                      child: Container(
                        height: 300, // Fixed height for the scrollable area
                        width: 500,
                        child: Obx(() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                UiStrings.selectedModules,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: ListView(
                                  children: controller.itemsMap.keys.map((String key) {
                                    return CheckboxListTile(
                                      title: Text(key),
                                      value: controller.itemsMap[key],
                                      onChanged: (bool? value) {
                                        // Assign the value directly to the controller's itemsMap
                                        if (value != null) {
                                          controller.itemsMap[key] = value;
                                        }
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                              Obx(() {
                                if (!controller.isModuleSelectionValid.value) {
                                  return Padding(
                                    padding: EdgeInsets.only(left: spacingWidth, top: 8),
                                    child: Text(
                                      'Please select at least one module.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink(); // Return an empty container when there's no error.
                                }
                              }),
                            ],
                          );
                        }),
                      ),
                    ),

                  ]),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xff000000), width: 2.0),
                      padding: const EdgeInsets.all(20),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(UiStrings.cancel,
                        style: TextStyle(color: Color(0xff000000))),
                  ),
                  SizedBox(width: 20),
                  TextButton(
                    onPressed: () async {
                      // Check if the form is valid
                      bool isFormValid =
                          controller.formKey.currentState!.validate();
                      // Check if at least one module is selected
                      bool isAtLeastOneModuleSelected =
                          controller.isModuleSelected();

                      controller.isModuleSelectionValid.value =
                          isAtLeastOneModuleSelected;

                      if (isFormValid && isAtLeastOneModuleSelected) {
                        controller.printFormData();

                        List<String> selectedModules = controller
                            .itemsMap.entries
                            .where((entry) => entry.value)
                            .map((entry) => entry.key)
                            .toList();

                        bool success =
                            await controller.createParticipantAndModules(
                                evaluator.evaluatorID!, selectedModules);

                        if (success) {
                          var homeCtrller = Get.find<HomeController>();
                          homeCtrller.refreshData();
                          Get.back();
                        }
                      } else {}
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(20),
                      textStyle: const TextStyle(fontSize: 16),
                      backgroundColor: Color(0xff17120f),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(UiStrings.register),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
