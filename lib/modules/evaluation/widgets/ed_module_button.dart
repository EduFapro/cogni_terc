import 'package:flutter/material.dart';

import '../../../constants/enums/module_enums.dart';

class ModuleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final ModuleStatus moduleStatus;

  const ModuleButton({
    Key? key,
    this.onPressed,
    required this.moduleStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Custom painter to draw the button with a border
    Widget buttonWithCustomPainter(Color backgroundColor, Color borderColor) {
      return CustomPaint(
        painter: _ButtonBorderPainter(borderColor: borderColor),
        child: Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: backgroundColor, // The background color goes inside the border.
            borderRadius: BorderRadius.circular(8.0), // The border radius.
          ),
          child: Center(
            child: Text(
              moduleStatus.description,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: moduleStatus == ModuleStatus.completed ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    Color getBackgroundColor() {
      switch (moduleStatus) {
        case ModuleStatus.pending:
          return Colors.white;
        case ModuleStatus.in_progress:
          return Colors.orange;
        case ModuleStatus.completed:
          return Colors.green;
        default:
          return Colors.white;
      }
    }

    Color getBorderColor() {
      switch (moduleStatus) {
        case ModuleStatus.pending:
          return Colors.blue;
        default:
          return Colors.black;
      }
    }

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8.0),
      child: buttonWithCustomPainter(getBackgroundColor(), getBorderColor()),
    );
  }
}


class _ButtonBorderPainter extends CustomPainter {
  final Color borderColor;

  _ButtonBorderPainter({required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final RRect borderRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(8.0),
    );

    canvas.drawRRect(borderRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
