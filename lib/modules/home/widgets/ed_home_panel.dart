import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/translation/ui_strings.dart';
import '../home_controller.dart';
import 'ed_evaluation_history.dart';
import 'ed_new_participant_button.dart';

class EdHomePanel extends GetView<HomeController> {
  const EdHomePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                UiStrings.home,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8.0),
              EdNewParticipantButton(),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: EdEvaluationHistory(),
        ),
      ],
    );
  }

}
