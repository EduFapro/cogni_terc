import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/translation/ui_strings.dart';
import '../../../routes.dart';

class EdNewParticipantButton extends StatelessWidget {
  const EdNewParticipantButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Get.toNamed(AppRoutes.participantRegistration);
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(20),
        textStyle: const TextStyle(fontSize: 16),
        backgroundColor: Color(0xff17120f),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.add, color: Colors.white),
          SizedBox(width: 4.0),
          Text(UiStrings.newParticipant),
        ],
      ),
    );
  }
}
