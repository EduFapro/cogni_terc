import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../constants/enums/evaluation_enums.dart';
import '../../../constants/route_arguments.dart';
import '../../../constants/translation/ui_strings.dart';
import '../../../routes.dart';
import '../../widgets/ed_input_text.dart';
import '../home_controller.dart';

class EdEvaluationHistory extends GetView<HomeController> {
  EdEvaluationHistory({Key? key}) : super(key: key);
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              UiStrings.evaluationHistory,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Column(
              children: <Widget>[
                Obx(
                  () => buildIconLabel(
                    context,
                    Icons.folder_open,
                    UiStrings.totalProjects,
                    controller.numEvaluationsTotal.value,
                  ),
                ),
                Obx(
                  () => buildIconLabel(
                    context,
                    Icons.hourglass_empty,
                    UiStrings.inProgress,
                    controller.numEvaluationsInProgress.value,
                  ),
                ),
                Obx(
                  () => buildIconLabel(
                    context,
                    Icons.check_circle_outline,
                    UiStrings.completed,
                    controller.numEvaluationsFinished.value,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              children: [
                EdSearchBar(
                  controller: controller.searchController,
                  onSearch: controller.performSearch,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 350,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.blueGrey.withOpacity(0.5),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Text("Filtrar por Status: "),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: StatusSwitchFilter(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        Obx(() {
          if (homeController.isLoading.isTrue) {
            return Center(child: CircularProgressIndicator());
          } else {
            return buildTable(homeController);
          }
        }),
      ],
    );
  }

  Widget buildTable(HomeController homeController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Table Header
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(UiStrings.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 2,
                child: Text(UiStrings.status,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 2,
                child: Text(UiStrings.evaluator,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 2,
                child: Text(UiStrings.date,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Divider(),
          Obx(() {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: homeController.filteredEvaluations.length,
              itemBuilder: (context, index) {
                final evaluation = homeController.filteredEvaluations[index];
                final dateFormat = DateFormat.yMd();
                final participant = controller.participants.firstWhere(
                  (element) =>
                      element.participantID! == (evaluation.participantID),
                );

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(participant.fullName ?? 'Unknown')),
                        Expanded(
                            flex: 2,
                            child: Text(evaluation.status.description)),
                        Expanded(
                            flex: 2,
                            child: Text(
                                homeController.user.value?.name ?? 'Unknown')),
                        Expanded(
                          flex: 2,
                          child: Text(evaluation.evaluationDate != null
                              ? dateFormat.format(evaluation.evaluationDate!)
                              : ''),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.evaluation,
                              arguments: {
                                RouteArguments.EVALUATOR: controller.user.value!,
                                RouteArguments.PARTICIPANT: participant,
                                RouteArguments.EVALUATION: evaluation,
                              },
                            );
                          },
                          child: const Icon(Icons.create_rounded),
                        ),
                        const Icon(Icons.delete),
                        GestureDetector(
                          onTap: () {
                            print(
                                'Download button tapped for evaluation ID: ${evaluation.evaluationID}');
                            homeController.handleDownload(
                                evaluation.evaluationID!,
                                evaluation.evaluatorID.toString(),
                                evaluation.participantID.toString());
                            homeController.createDownload(evaluation!);
                          },
                          child: const Icon(Icons.download_rounded),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget buildIconLabel(
      BuildContext context, IconData icon, String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 24.0),
          SizedBox(width: 8.0),
          Text('$label: $count'),
        ],
      ),
    );
  }
}

class StatusSwitchFilter extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        mainAxisSize: MainAxisSize.min, // Ensure the row takes minimum space
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              height: 35,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<EvaluationStatus>(
                  value: controller.selectedStatus.value,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  iconSize: 20,
                  elevation: 16,
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: Colors.black,
                  onChanged: (EvaluationStatus? newValue) {
                    controller.selectedStatus.value = newValue;
                    if (newValue == null) {
                      controller.resetFilters();
                    } else {
                      controller.filterEvaluationsByStatus();
                    }
                  },
                  items: EvaluationStatus.values
                      .map<DropdownMenuItem<EvaluationStatus>>(
                          (EvaluationStatus status) {
                    return DropdownMenuItem<EvaluationStatus>(
                      value: status,
                      child: Text(status.description,
                          style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  hint: controller.selectedStatus.value == null
                      ? Text(
                          "Select",
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.7)),
                        )
                      : null,
                ),
              ),
            ),
          ),
          if (controller.selectedStatus.value != null)
            IconButton(
              onPressed: () {
                controller.selectedStatus.value = null;
                controller.filterEvaluationsByStatus();
              },
              icon: Icon(Icons.close, color: Colors.black),
            ),
        ],
      );
    });
  }
}
