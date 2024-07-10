import 'package:flutter/material.dart';

class EdSkipButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  EdSkipButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
        elevation: 2, // Elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0), // Rounded corners
          side: BorderSide(color: Colors.black), // Border color and width
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding
      ),
    );
  }
}
