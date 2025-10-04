import 'package:flutter/material.dart';

class ActionGridItemPaint extends CustomPainter {
  final Color color;

  ActionGridItemPaint({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw decorative circles in corners
    canvas.drawCircle(Offset(10, 10), 20, paint);
    canvas.drawCircle(Offset(size.width - 10, size.height - 10), 25, paint);

    // Draw decorative arc
    final arcPaint = Paint()
      ..color = color.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.2,
        size.width,
        size.height * 0.4,
      );

    canvas.drawPath(path, arcPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
