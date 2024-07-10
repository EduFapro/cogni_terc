import 'package:flutter/material.dart';

class EdMainSidebarButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onPressed;
  final Color color;

  const EdMainSidebarButton({
    Key? key,
    required this.icon,
    this.color = Colors.black,
    required this.text, required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
      onPressed: () {
        onPressed();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white,),
          SizedBox(width: 8.0),
          Text(text, style: TextStyle(
            color: Colors.white
          ),),
        ],
      ),
    );
  }
}