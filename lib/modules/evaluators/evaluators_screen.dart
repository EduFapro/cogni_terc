import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/translation/ui_strings.dart';
import 'evaluators_controller.dart';
import 'widgets/ed_evaluators_list.dart';

class EvaluatorsScreen extends GetView<EvaluatorsController>  {
  const EvaluatorsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double bodyHeight = screenHeight * 0.85;

    return Scaffold(
      appBar: AppBar(
        title: Text(UiStrings.evaluators),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: bodyHeight,
        child: EdEvaluatorsList(placeholder: 'Search...',),
      ),
    );
  }
}
