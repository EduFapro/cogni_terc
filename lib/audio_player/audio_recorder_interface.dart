// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:path_provider/path_provider.dart';
// import 'audio_recorder_controller.dart';
//
// class AudioRecorderInterface extends StatelessWidget {
//   final void Function(String path) onStop;
//
//   AudioRecorderInterface({Key? key, required this.onStop}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final AudioRecorderController controller = Get.put(AudioRecorderController());
//
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Obx(() {
//           return IconButton(
//             icon: Icon(
//               controller.isRecording.value ? Icons.stop : Icons.mic,
//               size: 56.0,
//               color: controller.isRecording.value ? Colors.red : Colors.blue,
//             ),
//             onPressed: () async {
//               if (controller.isRecording.value) {
//                 String? path = await controller.stopRecording();
//                 if (path != null) onStop(path);
//               } else {
//                 String path = await _getRecordingPath();
//                 await controller.startRecording(path);
//               }
//             },
//           );
//         }),
//       ],
//     );
//   }
//
//   // Helper method to generate a path for the recording
//   Future<String> _getRecordingPath() async {
//     final directory = await getApplicationDocumentsDirectory();
//     String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.aac';
//     return '${directory.path}/$fileName';
//   }
// }
