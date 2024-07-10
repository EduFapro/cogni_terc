import 'package:cogni_terc/constants/enums/evaluation_enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/translation/ui_strings.dart';
import 'evaluation_controller.dart';
import 'widgets/ed_module_instance_item.dart';

class EvaluationScreen extends GetView<EvaluationController> {
  const EvaluationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(UiStrings.evaluation),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFFFDFDFD),
        width: screenWidth,
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              color: Color(0xFFE8E7E7),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: screenWidth * 0.8,
                  child: ParticipantCard(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: screenWidth,
              child: Text(
                UiStrings.listOfActivities,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: screenWidth * 0.4,
              child: Container(
                child: Obx(() {
                  if (controller.isLoading.isTrue) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    var futureModules = controller.modulesInstanceList.value
                            ?.map((moduleInstance) async {
                          var module = await moduleInstance.module;
                          var tasks = await controller
                              .getTasks(moduleInstance.moduleInstanceID!);
                          return EdModuleInstanceItem(
                            moduleName: module!.title!,
                            moduleInstace: moduleInstance,
                            taskInstances: tasks,
                          );
                        }).toList() ??
                        [];

                    return FutureBuilder<List<EdModuleInstanceItem>>(
                      future: Future.wait(futureModules),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Text('No modules available');
                        }
                        return Column(
                          children: snapshot.data!
                              .map((moduleItem) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    // Adjust the padding as needed
                                    child: moduleItem,
                                  ))
                              .toList(),
                        );
                      },
                    );
                  }
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ParticipantCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final EvaluationController controller = Get.find<EvaluationController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildRichText("Nome", controller.participant.value?.fullName ?? ''),
        buildRichText("Idade", "${controller.age} anos"),
        buildRichText(
            "Status", controller.evaluation.value!.status.description),
      ],
    );
  }

  RichText buildRichText(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          TextSpan(
            text: value,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
