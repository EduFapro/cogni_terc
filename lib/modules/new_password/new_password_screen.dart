import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../mixins/ValidationMixin.dart';

import '../../routes.dart';
import '../widgets/ed_form_title.dart';
import '../widgets/ed_input_text.dart';
import 'new_password_controller.dart';

class NewPasswordScreen extends GetView<NewPasswordController>
    with ValidationMixin {
  NewPasswordScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  String firstPassword = '';
  String secondPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 500, maxWidth: 500),
            child: Container(
              padding: const EdgeInsets.all(48),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: const BorderRadius.all(Radius.circular(24)),
              ),
              child: Form(
                key: formKey,
                child: Wrap(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FormTitle(title: 'New Password'),
                        const SizedBox(height: 10.0),
                        EdInputText(
                          placeholder: "Password",
                          obscureText: true,
                          validator: (value) {
                            return validatePassword(value);
                          },
                          onSaved: (value) => firstPassword = value ?? '',
                        ),
                        const SizedBox(height: 10.0),
                        EdInputText(
                          placeholder: "Confirm Password",
                          obscureText: true,
                          validator: (value) {
                            return validateSecondPassword(value, firstPassword);
                          },
                          onSaved: (value) => secondPassword = value ?? '',
                        ),
                        const SizedBox(height: 20.0),
                        const SizedBox(height: 20.0),
                        TextButton(
                          onPressed: () async {
                            formKey.currentState!.save();

                            if (firstPassword == secondPassword) {
                              await controller.changePassword(firstPassword);
                              Get.toNamed(AppRoutes.home);
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(20),
                            textStyle: const TextStyle(fontSize: 16),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Confirm"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF161E2E),
    );
  }
}
