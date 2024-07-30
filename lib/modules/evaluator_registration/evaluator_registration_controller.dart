import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/evaluator/evaluator_entity.dart';
import '../../app/evaluator/evaluator_repository.dart';
import '../../constants/route_arguments.dart';
import '../../constants/translation/ui_messages.dart';
import '../../constants/translation/ui_strings.dart';
import '../../mixins/ValidationMixin.dart';
import '../evaluators/evaluators_controller.dart';

class EvaluatorRegistrationController extends GetxController
    with ValidationMixin {
  final EvaluatorRepository _repository;
  final EvaluatorsController _evaluatorsController;

  EvaluatorRegistrationController(this._repository, this._evaluatorsController);

  final Rx<EvaluatorEntity?> evaluator = Rxn<EvaluatorEntity>();
  final fullNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final specialtyController = TextEditingController();
  final cpfOrNifController = TextEditingController();
  final usernameController = TextEditingController();
  final RxString username = ''.obs;
  final RxString originalUsername = ''.obs;
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  final RxBool isPasswordChangeEnabled = false.obs;

  final RxBool isEditMode = false.obs;
  var selectedDate = Rx<DateTime?>(null);
  var isGeneratingUsername = false.obs;
  var isUsernameValid = false.obs;
  final FocusNode fullNameFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final RxBool isUsernameModified = false.obs;
  final RxBool saveAsAdmin = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null &&
        Get.arguments[RouteArguments.EVALUATOR] != null &&
        Get.arguments[RouteArguments.CONFIG_ADMIN] == null) {
      isEditMode.value = true;
      evaluator.value = Get.arguments[RouteArguments.EVALUATOR];
      if (evaluator.value != null) {
        _populateFieldsWithEvaluatorData(evaluator.value!.evaluatorID!);
        isUsernameValid.value = true;
      }
    } else {
      isEditMode.value = false;
    }

    if (Get.arguments != null &&
        Get.arguments[RouteArguments.CONFIG_ADMIN] != null) {
      saveAsAdmin.value = Get.arguments[RouteArguments.CONFIG_ADMIN];
    }
    fullNameFocusNode.addListener(() {
      if (!fullNameFocusNode.hasFocus && !isEditMode.value) {
        final validationResult = validateFullName(fullNameController.text);
        if (validationResult == null) {
          String baseUsername = generateUsername(fullNameController.text, []);
          checkAndUpdateUsername(baseUsername);
        } else {
          username.value = '';
          isUsernameValid.value = false;
        }
      }
    });

    usernameController.addListener(() {
      if (isEditMode.value) {
        isUsernameModified.value =
            usernameController.text != originalUsername.value;
      }
    });

    if (isEditMode.isTrue && evaluator.value != null) {
      originalUsername.value = evaluator.value!.username;
    }

    print("Edit mode: ${isEditMode.value}");
  }

  Future<void> _populateFieldsWithEvaluatorData(int evaluatorId) async {
    try {
      final evaluator = await _repository.getEvaluator(evaluatorId);
      if (evaluator != null) {
        fullNameController.text = '${evaluator.name} ${evaluator.surname}';
        dateOfBirthController.text =
            DateFormat.yMd().format(evaluator.birthDate);
        specialtyController.text = evaluator.specialty ?? '';
        cpfOrNifController.text = evaluator.cpfOrNif ?? '';
        usernameController.text = evaluator.username;
        username.value = evaluator.username;
        selectedDate.value = evaluator.birthDate;

        // Assuming you have methods to set initial values for other fields if needed
      }
    } catch (e) {
      print("Error fetching evaluator data: $e");
    }
  }

  void selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      locale: Get.locale,
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
      dateOfBirthController.text = DateFormat.yMd().format(pickedDate);
    }
  }

  Future<bool> createEvaluator() async {
    var cpf = cpfOrNifController.text;

    // Check if CPF is already registered
    bool cpfExists = await _repository.evaluatorCpfExists(cpf);
    if (cpfExists) {
      Get.snackbar(UiStrings.error, UiMessages.cpfAlreadyInUse);
      return false;
    }

    var fullName = fullNameController.text;
    List<String> parts = fullName.split(' ');

    var firstName = parts.first;
    var lastName = parts.skip(1).join(' ');

    DateTime? parsedDate;
    try {
      parsedDate = DateFormat.yMd().parse(dateOfBirthController.text);
    } catch (e) {
      print('Error parsing date: $e');
      return false;
    }

    // if (selectedSex.value == null) {
    //   print('Date or Sex is null. Aborting.');
    //   return false;
    // }

    print("PRINTZERA ${saveAsAdmin.value}");
    EvaluatorEntity newEvaluator = EvaluatorEntity(
      name: firstName,
      surname: lastName,
      birthDate: parsedDate,
      // sex: selectedSex.value!,
      specialty: specialtyController.text,
      cpfOrNif: cpfOrNifController.text,
      username: username.value,
      firstLogin: true,
      password: cpfOrNifController.text,
      isAdmin: saveAsAdmin.value,
    );

    try {
      // Attempt to create a new evaluator in the database and receive an ID.
      int? evaluatorId = await _repository.createEvaluator(newEvaluator);

      // Use the copyWith method to create a new instance of EvaluatorEntity with the received ID.
      EvaluatorEntity updatedEvaluator =
          newEvaluator.copyWith(evaluatorID: evaluatorId);
      print(updatedEvaluator);
      // Add the updated evaluator to the controller.
      _evaluatorsController.addEvaluator(updatedEvaluator);

      // Return true to indicate success.
      return true;
    } catch (e) {
      // If there's an error, print it and return false.
      print('Error creating evaluator: $e');
      return false;
    } finally {
      isEditMode.value = false;
    }
  }

  String generateUsername(String fullName, List<String> existingUsernames) {
    List<String> words = fullName.split(' ');

    String baseUsername =
        "${words.first.toLowerCase()}_${words.last.toLowerCase()}";
    String username = baseUsername;
    int counter = 1;

    while (existingUsernames.contains(username)) {
      username = '$baseUsername$counter';
      counter++;
    }

    return username;
  }

  @override
  void onClose() {
    fullNameController.dispose();
    dateOfBirthController.dispose();
    specialtyController.dispose();
    cpfOrNifController.dispose();
    usernameController.dispose();
    fullNameFocusNode.dispose();

    newPasswordController.dispose();
    confirmNewPasswordController.dispose();

    super.onClose();
  }

  void printFormData() {
    print('Full Name: ${fullNameController.text}');
    print('Date of Birth: ${dateOfBirthController.text}');
    // print('Sex: ${selectedSex.value == Sex.male ? 'Male' : 'Female'}');
    print('Specialty: ${specialtyController.text}');
    print('CPF/NIF: ${cpfOrNifController.text}');
    print('Username: ${usernameController.text}');
  }

  Future<void> checkAndUpdateUsername(String baseUsername) async {
    int counter = 2;
    String currentUsername = baseUsername;
    EvaluatorEntity? existingEvaluator;

    // This pattern will match if the username ends with a number
    final numberSuffixPattern = RegExp(r'(\d+)$');

    username.value = currentUsername;
    usernameController.text = currentUsername; // Update the controller

    if (isEditMode.isTrue && !isUsernameModified.value) {
      isUsernameValid.value = true;
      return;
    }

    while (true) {
      existingEvaluator =
          await _repository.getEvaluatorByUsername(currentUsername);
      if (existingEvaluator != null) {
        // Check if the existing username ends with a number
        final match =
            numberSuffixPattern.firstMatch(existingEvaluator.username);
        if (match != null) {
          // If it does, parse the number, increment it, and append to the base username
          final number = int.parse(match.group(1)!);
          currentUsername = '$baseUsername${number + 1}';
        } else {
          // If it doesn't end with a number, simply append '2' or increment counter
          currentUsername = '$baseUsername$counter';
        }
        counter++; // Increment the counter for the next potential loop iteration
      } else {
        break; // Unique username found, exit the loop
      }
    }

    // Found a unique username, update the observable
    username.value = currentUsername;
    usernameController.text = currentUsername; // Update the controller
    isUsernameValid.value = true;
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  void togglePasswordVisibility() {
    isPasswordChangeEnabled.value = !isPasswordChangeEnabled.value;
  }

  Future<bool> saveEvaluator() async {
    if (isEditMode.isTrue) {
      return updateEvaluator();
    } else {
      return createEvaluator();
    }
  }

  Future<bool> updateEvaluator() async {
    print("AIAIAI");
    var cpf = cpfOrNifController.text;
    var evaluatorId = evaluator.value!.evaluatorID!;

    // Check if CPF is registered to another evaluator
    bool cpfExistsForOther =
        await _repository.evaluatorCpfExistsForOther(evaluatorId, cpf);
    if (cpfExistsForOther) {
      Get.snackbar(UiStrings.error, UiMessages.cpfAlreadyInUse);
      return false;
    }

    // Validate username if it has been modified
    if (isEditMode.isTrue && isUsernameModified.value) {
      await checkAndUpdateUsername(usernameController.text);
      if (!isUsernameValid.value) {
        print('Username is invalid'); // Debugging print statement
        return false;
      }
    }

    // Construct the EvaluatorEntity object with updated data
    EvaluatorEntity updatedEvaluator = evaluator.value!.copyWith(
      name: fullNameController.text.split(' ').first,
      surname: fullNameController.text.split(' ').skip(1).join(' '),
      birthDate: selectedDate.value!,
      specialty: specialtyController.text,
      cpfOrNif: cpfOrNifController.text,
      username: usernameController.text,
    );

    // Check if passwords should be updated
    if (isPasswordChangeEnabled.value &&
        newPasswordController.text.isNotEmpty) {
      updatedEvaluator =
          updatedEvaluator.copyWith(password: newPasswordController.text);
    }

    print(updatedEvaluator);
    // Attempt to update the evaluator in the database
    int updateCount = await _repository.updateEvaluator(updatedEvaluator);
    if (updateCount == 1) {
      _evaluatorsController.updateEvaluatorInList(updatedEvaluator);
      return true;
    } else {
      // Update failed
      Get.snackbar('Error', 'Failed to update the evaluator.');
      return false;
    }
  }
}
