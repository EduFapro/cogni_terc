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
    final screenWidth = MediaQuery.of(context).size.width;
    final HomeController homeController = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Header section with title and status icons
        Text(
          UiStrings.evaluationHistory,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        // Status counters
        Obx(() => buildIconLabel(
          context,
          Icons.folder_open,
          UiStrings.totalProjects,
          controller.numEvaluationsTotal.value,
        )),
        Obx(() => buildIconLabel(
          context,
          Icons.hourglass_empty,
          UiStrings.inProgress,
          controller.numEvaluationsInProgress.value,
        )),
        Obx(() => buildIconLabel(
          context,
          Icons.check_circle_outline,
          UiStrings.completed,
          controller.numEvaluationsFinished.value,
        )),
        SizedBox(height: 20),
        // Search bar and filter by status dropdown
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
        ),
        // Evaluation table
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
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(2),
          4: FixedColumnWidth(200),
        },
        children: [
          TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(UiStrings.name, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(UiStrings.status, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(UiStrings.evaluator, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(UiStrings.date, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              TableCell(child: SizedBox.shrink()), // Empty cell for action icons
            ],
          ),
          TableRow(
            children: [
              TableCell(child: Divider()),
              TableCell(child: Divider()),
              TableCell(child: Divider()),
              TableCell(child: Divider()),
              TableCell(child: Divider()),
            ],
          ),
          ...homeController.filteredEvaluations.map((evaluation) {
            final participant = controller.participants.firstWhere(
                  (element) => element.participantID == evaluation.participantID,
            );

            return TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(participant.fullName ?? 'Unknown'),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(evaluation.status.description),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(homeController.user.value?.name ?? 'Unknown'),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(dateFormat.format(evaluation.evaluationDate!)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        iconWithHoverEffect(evaluation.evaluationID!, Icons.create_rounded, () {
                          Get.toNamed(
                            AppRoutes.evaluation,
                            arguments: {
                              RouteArguments.EVALUATOR: controller.user.value!,
                              RouteArguments.PARTICIPANT: participant,
                              RouteArguments.EVALUATION: evaluation,
                            },
                          );
                        }, "Abrir"),
                        SizedBox(width: 8),
                        iconWithHoverEffect(evaluation.evaluationID!, Icons.delete, () {
                          controller.deleteEvaluation(evaluation: evaluation);
                        }, "Deletar"),
                        SizedBox(width: 8),
                        iconWithHoverEffect(evaluation.evaluationID!, Icons.download_rounded, () {
                          homeController.handleDownload(
                            evaluation.evaluationID!,
                            evaluation.evaluatorID.toString(),
                            evaluation.participantID.toString(),
                          );
                          homeController.createDownload(evaluation);
                        }, "Download"),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
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
          Text('$label: $count',),
        ],
      ),
    );
  }

  Widget iconWithHoverEffect(int evaluationID, IconData iconData,
      void Function()? onTap, String label) {
    int uniqueKey = evaluationID.hashCode ^ iconData.hashCode;

    return Obx(() {
      bool isHovering = controller.hoverStates[uniqueKey]?.value ?? false;
      return MouseRegion(
        onEnter: (_) => controller.setHoverState(evaluationID, iconData, true),
        onExit: (_) => controller.setHoverState(evaluationID, iconData, false),
        child: Column(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Icon(
                iconData,
                color: isHovering ? Colors.blue : Colors.grey,
              ),
            ),
            Text(label, style: TextStyle(fontSize: 14),),
          ],
        ),
      );
    });
  }
}

class StatusSwitchFilter extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        mainAxisSize: MainAxisSize.min,
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
                    UiStrings.select,
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
                controller.resetFilters();
              },
              icon: Icon(Icons.close, color: Colors.black),
            ),
        ],
      );
    });
  }
}
