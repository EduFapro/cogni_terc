// import 'package:get/get.dart';
// import 'package:record/record.dart';
//
// class AudioRecorderController extends GetxController {
//   late final AudioRecorder _recorder;
//   RxBool isRecording = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _recorder = AudioRecorder(); // Initialize your audio recorder here
//   }
//
//   Future<void> startRecording(String path) async {
//     bool hasPermission = await _recorder.hasPermission();
//     if (hasPermission) {
//       // Define the configuration for recording
//       var config = RecordConfig(
//         encoder: AudioEncoder.aacLc,
//         bitRate: 128000, // Example bitrate
//         sampleRate: 44100, // Example sample rate
//       );
//
//       await _recorder.start(config, path: path);
//       isRecording.value = true;
//     }
//   }
//
//   Future<void> pauseRecording() async {
//     await _recorder.pause();
//     isRecording.value = false;
//   }
//
//   Future<String?> stopRecording() async {
//     final path = await _recorder.stop();
//     isRecording.value = false;
//     return path;
//   }
//
//   @override
//   void onClose() {
//     _recorder.dispose();
//     super.onClose();
//   }
// }
