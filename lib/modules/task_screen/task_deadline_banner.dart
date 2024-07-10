import 'package:flutter/material.dart';

class TaskDeadlineBanner extends StatelessWidget {
  final String deadlineText;

  const TaskDeadlineBanner({
    Key? key,
    required this.deadlineText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        deadlineText,
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }
}
