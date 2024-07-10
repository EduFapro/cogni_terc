import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../app/evaluator/evaluator_entity.dart';
import '../../../constants/translation/ui_strings.dart';
import '../../../routes.dart';
import '../evaluators_controller.dart';

class EdNewEvaluatorButton extends StatelessWidget {
  const EdNewEvaluatorButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        // Navigate and wait for the result
        var result = await Get.toNamed(AppRoutes.evaluatorRegistration);
        // If the result is a new Evaluator, add it to the list
        if (result is EvaluatorEntity) {
          final EvaluatorsController controller = Get.find();
          controller.addEvaluator(result);
        }
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.add, color: Colors.white),
          SizedBox(width: 4.0),
          Text(UiStrings.newEvaluator),
        ],
      ),
    );
  }
}
