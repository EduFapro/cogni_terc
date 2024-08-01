import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../constants/enums/task_enums.dart';
import '../../constants/translation/ui_messages.dart';
import '../../constants/translation/ui_strings.dart';
import '../evaluation/evaluation_controller.dart';
import '../widgets/music_visualizer.dart';
import 'countdown_timer.dart';
import 'task_screen_controller.dart';

class TaskScreen extends GetView<TaskScreenController> {
  TaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var windowsSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (controller.isModuleCompleted.isTrue) {
                final evalController = Get.find<EvaluationController>();
                evalController.markModuleAsCompleted(
                    controller.moduleInstance.value!.moduleInstanceID!);
              }
              Get.back();
            }),
      ),
      body: Container(
        color: Colors.yellow,
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isModuleCompleted.isTrue) {
                  return TaskCompletedWidget(onNavigateBack: () {
                    final evalController = Get.find<EvaluationController>();
                    evalController.markModuleAsCompleted(
                        controller.moduleInstance.value!.moduleInstanceID!);
                    Get.back();
                  });
                } else if (controller.currentTask.value != null) {
                  var mode = controller.taskMode.value;
                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.red,
                        padding: EdgeInsets.symmetric(
                            horizontal: (windowsSize.width * 0.30)),
                        child: CustomLinearPercentIndicator(
                          current: controller.currentTaskIndex.value,
                          total: controller.totalTasks.value,
                        ),
                      ),
                      Container(
                        color: Colors.blueAccent,
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Container(
                        color: Colors.purple,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade400,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${controller.currentTaskEntity.value?.title ?? 'Unknown'}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              color: Colors.white,
                              child: CustomIconButton(
                                  iconData: Icons.double_arrow_outlined,
                                  label: "Pular e Próximo",
                                  onPressed: () => controller.skipCurrentTask(),
                                  isActive: true.obs,
                                  displayMessage: "Atividade Pulada"),
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: Container(
                            color: Colors.green,
                            child: Center(
                                child:
                                    buildInterfaceBasedOnMode(context, mode))),
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
            ),
            // NAO APAGAR
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: SizedBox(
            //       width: MediaQuery.of(context).size.width * 0.4,
            //       child: buildAccordion(context)),
            // )
            // NAO APAGAR
          ],
        ),
      ),
    );
  }

  Widget buildInterfaceBasedOnMode(BuildContext context, TaskMode mode) {
    final Size windowSize = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          width: 880,
          child: Column(
            children: [
              CountdownTimer(
                countdownTrigger: controller.countdownTrigger,
                initialDurationInSeconds:
                    controller.task.value!.timeForCompletion,
                onTimerComplete: _onTimeCompleted,
              ),
              Card(
                color: Color(0xFFD7D7D7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        UiStrings.clickOnPlayToListenToTheTask,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                color: controller.shouldDisablePlayButton.value
                                    ? Colors.redAccent.shade100
                                    : Colors.black54,
                                disabledColor: Colors.redAccent.shade100,
                                iconSize: 48,
                                icon: Icon(controller.isPlaying.value
                                    ? Icons.stop
                                    : Icons.play_arrow),
                                onPressed:
                                    controller.shouldDisablePlayButton.value
                                        ? null
                                        : () => controller.togglePlay(),
                              ),
                              Text(UiStrings.play_audio,
                                  style: TextStyle(fontSize: 16)),
                              // Subtitle label
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                width: windowSize.width * 0.4,
                                height: 80,
                                child: MusicVisualizer(
                                  isPlaying: controller.isPlaying.value,
                                  barCount: 30, // Example: 30 bars
                                  barWidth:
                                      3, // Example: Each bar is 3 pixels wide
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (mode == TaskMode.play) buildAudioPlayerInterface(context),
        if (mode == TaskMode.record)
          buildAudioRecorderInterface(context, controller),
        Container(
          color: Colors.purple,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Expanded(
                  child: Container(
                color: Colors.white,
                child: CustomIconButton(
                    iconData: Icons.check,
                    label: UiStrings.confirm,
                    onPressed: () => controller.onCheckButtonPressed(),
                    isActive: controller.isCheckButtonEnabled,
                    displayMessage: "Atividade Concluída"),
              ))
            ],
          ),
        ),
      ],
    );
  }

  Widget buildGeneralInterface(BuildContext context) {
    final Size windowSize = MediaQuery.of(context).size;
    return SizedBox(
      width: 880,
      child: Column(
        children: [
          CountdownTimer(
            countdownTrigger: controller.countdownTrigger,
            initialDurationInSeconds: controller.task.value!.timeForCompletion,
            onTimerComplete: _onTimeCompleted,
          ),
          Card(
            color: Color(0xFFD7D7D7),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    UiStrings.clickOnPlayToListenToTheTask,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            color: controller.shouldDisablePlayButton.value
                                ? Colors.redAccent.shade100
                                : Colors.black54,
                            disabledColor: Colors.redAccent.shade100,
                            iconSize: 48,
                            icon: Icon(controller.isPlaying.value
                                ? Icons.stop
                                : Icons.play_arrow),
                            onPressed: controller.shouldDisablePlayButton.value
                                ? null
                                : () => controller.togglePlay(),
                          ),
                          Text(UiStrings.play_audio,
                              style: TextStyle(fontSize: 16)),
                          // Subtitle label
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            width: windowSize.width * 0.4,
                            height: 80,
                            child: MusicVisualizer(
                              isPlaying: controller.isPlaying.value,
                              barCount: 30, // Example: 30 bars
                              barWidth: 3, // Example: Each bar is 3 pixels wide
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAudioPlayerInterface(BuildContext context) {
    final Size windowSize = MediaQuery.of(context).size;
    return Container(
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(
                width: windowSize.width * 0.4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: windowSize.width * 0.2,
                    ),
                    // CustomIconButton(
                    //     iconData: Icons.close,
                    //     label: "Pular",
                    //     onPressed: () => controller.skipCurrentTask(),
                    //     isActive: true.obs,
                    //     displayMessage: "Atividade Pulada"),
                    // CustomIconButton(
                    //     iconData: Icons.check,
                    //     label: UiStrings.confirm,
                    //     onPressed: () => controller.onCheckButtonPressed(),
                    //     isActive: controller.isCheckButtonEnabled,
                    //     displayMessage: "Atividade Concluída"),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget buildAudioRecorderInterface(
      BuildContext context, TaskScreenController controller) {
    final Size windowSize = MediaQuery.of(context).size;
    final recorderInterfaceHeight = windowSize.height * 0.40;
    final TaskScreenController controller = Get.find<TaskScreenController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 400.0),
      child: Container(
        height: recorderInterfaceHeight,
        // color: Colors.pink,
        child: Center(
          // Center the row
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // Space out items equally
                crossAxisAlignment: CrossAxisAlignment.center,
                // Vertically center items
                children: [
                  // CustomIconButton(
                  //     iconData: Icons.close,
                  //     label: "Pular",
                  //     onPressed: () => controller.skipCurrentTask(),
                  //     isActive: true.obs,
                  //     displayMessage: "Atividade Pulada"),
                  CustomRecordingButton(controller: controller),
                  // CustomIconButton(
                  //     iconData: Icons.check,
                  //     label: UiStrings.confirm,
                  //     onPressed: () => controller.onCheckButtonPressed(),
                  //     isActive: controller.isCheckButtonEnabled,
                  //     displayMessage: "Atividade Concluída"),
                ],
              ),
              Obx(() => Flexible(
                    flex: 6,
                    child: Container(
                      width: 500,
                      child: SizedBox(
                        height: 100,
                        child: (controller.hasPlaybackPath.isFalse)
                            ? MusicVisualizer(
                                isPlaying: controller.isRecording.value,
                                barCount: 30,
                                barWidth: 2,
                                activeColor: Colors.red,
                              )
                            : Container(
                                color: Colors.orange,
                                child: Row(
                                  children: [
                                    IconButton(
                                        color: Colors.black54,
                                        iconSize: 48,
                                        icon: Icon(
                                            controller.isPlayingPlayback.value
                                                ? Icons.stop
                                                : Icons.play_arrow),
                                        onPressed: controller
                                                .hasPlaybackPath.value
                                            ? controller.isPlayingPlayback.value
                                                ? () => controller
                                                    .stopRecentlyRecorded()
                                                : () => controller
                                                    .playRecentlyRecorded()
                                            : null),
                                    Container(
                                      color: Colors.lightBlue,
                                      width: 400,
                                      child: MusicVisualizer(
                                        isPlaying:
                                            controller.isPlayingPlayback.value,
                                        activeColor: Colors.greenAccent.shade700,
                                        barCount: 20,
                                        barWidth: 2,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _onTimeCompleted() async {
    // Play time up sound
    final audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource('audio/climbing_fast_sound_effect.mp3'));

    if (controller.isRecording.value) {
      await controller.stopRecording(); // Stop the recording
    }

    // Show time up dialog
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                UiStrings.timeUp,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                UiMessages.taskCompleted,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.back(); // Close the dialog
                  audioPlayer.stop(); // Stop the sound if needed
                  controller.onCheckButtonPressed();
                },
                child: Text('OK'),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false, // Disables popup to close by tapping outside
    );
  }

  Widget buildAccordion(BuildContext context) {
    var controller = Get.find<TaskScreenController>();
    return ExpansionTile(
      shape: Border(),
      initiallyExpanded: false,
      // Set to true if you want the accordion to be expanded initially
      title:
          Text("Task Details", style: TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Evaluator: ${'controller.evaluatorName'}",
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text("Participant: ${'controller.participantName'}",
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text("Module: ${'controller.moduleName'}",
                  style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final String label;
  final VoidCallback onPressed;
  final RxBool isActive;
  String? displayMessage;

  CustomIconButton({
    Key? key,
    required this.iconData,
    required this.onPressed,
    required this.isActive,
    required this.label,
    this.displayMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(iconData, size: 40),
            // Consistent size with recording button
            color: isActive.value ? Colors.blue : Colors.grey,
            onPressed: isActive.value
                ? () {
                    onPressed();
                    displayMessage != null
                        ? Get.snackbar(
                            "Ação", // Title
                            displayMessage!, // Message
                            snackPosition: SnackPosition.BOTTOM,
                            // Position of the snackbar
                            backgroundColor: Colors.blue,
                            colorText: Colors.white,
                            borderRadius: 20,
                            margin: EdgeInsets.all(15),
                            duration: Duration(milliseconds: 1000),
                            // Duration of the snackbar
                            isDismissible: true,
                            // Allow the snackbar to be dismissed
                            dismissDirection: DismissDirection
                                .horizontal, // Dismiss direction
                          )
                        : null;
                  }
                : null,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            // Add some space above the label
            child: Text(label, style: TextStyle(fontSize: 12)),
          ),
        ],
      );
    });
  }
}

class CustomRecordingButton extends StatelessWidget {
  final TaskScreenController controller;

  CustomRecordingButton({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var label = controller.isRecording.value ? "Parar" : "Gravar";
      var message = controller.isRecording.value
          ? "Gravação parada."
          : "Iniciando Gravação";

      return Column(
        mainAxisSize: MainAxisSize.min, // Use the minimum space available
        children: [
          Container(
            width: 100, // Consistent size with other buttons
            height: 100, // Consistent size with other buttons
            decoration: BoxDecoration(
              color: controller.isRecordButtonEnabled.value
                  ? (controller.isRecording.value
                      ? Colors.redAccent.shade100
                      : Colors.blue.shade100)
                  : Colors.grey.shade400, // Grey color for disabled state
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              icon: Icon(
                controller.isRecording.value ? Icons.stop : Icons.mic,
                size: 80, // Adjust the size of the icon if necessary
              ),
              color: controller.isRecordButtonEnabled.value
                  ? (controller.isRecording.value ? Colors.red : Colors.blue)
                  : Colors.grey, // Grey icon for disabled state
              onPressed: controller.isRecordButtonEnabled.value
                  ? () async {
                      if (controller.isRecording.value) {
                        await controller.stopRecording();
                      } else {
                        await controller.startRecording();
                      }

                      Get.snackbar("Ação", message,
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(milliseconds: 1500));
                    }
                  : null, // Disable the button if isRecordButtonEnabled is false
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            // Space between icon and text
            child: Text(label,
                style: TextStyle(fontSize: 16)), // Use the variable label
          ),
        ],
      );
    });
  }
}

class NumericProgressIndicator extends StatelessWidget {
  final int current;
  final int total;

  const NumericProgressIndicator({
    Key? key,
    required this.current,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$current / $total',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

class TaskCompletedWidget extends StatelessWidget {
  final VoidCallback onNavigateBack;

  const TaskCompletedWidget({
    Key? key,
    required this.onNavigateBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 120,
            color: Colors.green,
          ),
          Text(
            UiMessages.allTasksCompleted,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onNavigateBack,
            child: Text(UiStrings.goBack),
          ),
        ],
      ),
    );
  }
}

class CustomLinearPercentIndicator extends StatelessWidget {
  final int current;
  final int total;

  const CustomLinearPercentIndicator({
    Key? key,
    required this.current,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the percent value
    final double percent = total != 0 ? (current - 1) / total : 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          LinearPercentIndicator(
            lineHeight: 20.0,
            percent: percent,
            backgroundColor: Colors.grey,
            progressColor: Colors.blue,
            barRadius: const Radius.circular(10),
          ),
          Text(
            '${current - 1}/ $total',
            style: TextStyle(
              color: Colors.black, // Color that contrasts with the bar color
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
