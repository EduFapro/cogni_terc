// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:novo_cogni/audio_player/widgets/ed_check_icon_button.dart';
// import 'package:novo_cogni/audio_player/widgets/ed_skip_button.dart';
// import 'audio_player_controller.dart';
//
// class AudioPlayerInterface extends StatelessWidget {
//   final String audioPath;
//
//   AudioPlayerInterface({Key? key, required this.audioPath}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final AudioPlayerController controller = Get.put(AudioPlayerController());
//     final Size windowSize = MediaQuery.of(context).size;
//
//     return Card(
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Obx(() => Column(
//           children: [
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 IconButton(
//                   iconSize: 48, // Larger icon size
//                   icon: Icon(controller.isPlaying.value ? Icons.stop : Icons.play_arrow),
//                   onPressed: () => controller.togglePlay(audioPath),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: SizedBox(
//                     width: windowSize.width * 0.7,
//                     height: 80,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(5.0),
//                       ),
//                       child: CustomPaint(
//                         painter: WaveformPainter(),
//                       ),
//                     ),
//                   ),
//                 ),
//                 EdCheckIconButton(
//                   onPressed: () {
//                     // Handle the button press
//                   },
//                 )
//
//               ],
//             ),
//             EdSkipButton(
//               text: 'Pular',
//               onPressed: () {
//                 // Handle the button press
//               },
//             )
//           ],
//         )),
//       ),
//     );
//   }
// }
//
// class WaveformPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint()
//       ..color = Colors.blue
//       ..strokeWidth = 5; // Slightly thicker line for better visibility
//
//     // Draw a simple line for now
//     canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
