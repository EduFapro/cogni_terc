// import 'package:get/get.dart';
// import 'package:audioplayers/audioplayers.dart';
//
// class AudioPlayerController extends GetxController {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   var isPlaying = false.obs; // Observable state for playing status
//
//   Future<void> togglePlay(String path) async {
//     if (isPlaying.value) {
//       stop();
//     } else {
//       play(path);
//     }
//   }
//
//   Future<void> play(String path) async {
//     Source source = DeviceFileSource(path);
//     await _audioPlayer.play(source);
//     isPlaying.value = true;
//   }
//
//   void stop() {
//     _audioPlayer.stop();
//     isPlaying.value = false;
//   }
//
//   @override
//   void onClose() {
//     _audioPlayer.dispose();
//     super.onClose();
//   }
// }
//
