import 'package:flutter/material.dart';

class EdCheckIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  EdCheckIconButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black, // Color for the border
          width: 2.0, // Border width
        ),
      ),
      child: IconButton(
        icon: Icon(Icons.check),
        onPressed: onPressed,
      ),
    );
  }
}
