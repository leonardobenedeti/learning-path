import 'package:flutter/material.dart';

class PathLinePainter extends CustomPainter {
  final bool hasLineAbove;
  final bool hasLineBelow;
  final Color color;

  PathLinePainter({
    required this.hasLineAbove,
    required this.hasLineBelow,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final startX = size.width / 2;
    final centerY = size.height / 2;

    if (hasLineAbove) {
      canvas.drawLine(Offset(startX, 0), Offset(startX, centerY), paint);
    }

    if (hasLineBelow) {
      canvas.drawLine(
        Offset(startX, centerY),
        Offset(startX, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
