import 'package:flutter/material.dart';

class ChatBubblePaint extends CustomPainter {
  final Color color;
  final bool isSender;

  ChatBubblePaint({required this.color, required this.isSender});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    const double radius = 14.0;

    if (isSender) {
      path.moveTo(radius, 0);
      path.lineTo(size.width - radius, 0);
      path.arcToPoint(Offset(size.width, radius), radius: const Radius.circular(radius));
      path.lineTo(size.width, size.height - 10);
      path.quadraticBezierTo(size.width, size.height, size.width + 10, size.height);
      path.quadraticBezierTo(size.width, size.height, size.width - 10, size.height);
      path.lineTo(radius, size.height);
      path.arcToPoint(Offset(0, size.height - radius), radius: const Radius.circular(radius));
      path.lineTo(0, radius);
      path.arcToPoint(Offset(radius, 0), radius: const Radius.circular(radius));
    } else {
      // Top-left corner — NO offset
      path.moveTo(radius, 0);
      path.lineTo(size.width - radius, 0);
      path.arcToPoint(Offset(size.width, radius), radius: const Radius.circular(radius));
      path.lineTo(size.width, size.height - radius);
      path.arcToPoint(Offset(size.width - radius, size.height), radius: const Radius.circular(radius));

      // Bottom edge stops before the tail
      path.lineTo(10, size.height);

      // Tail: curves out to the left and slightly below, then comes back up
      path.quadraticBezierTo(0, size.height, -8, size.height);
      path.quadraticBezierTo(0, size.height - 2, 0, size.height - 14);

      // Up the left side
      path.lineTo(0, radius);
      // Top-left corner arc — matches moveTo
      path.arcToPoint(Offset(radius, 0), radius: const Radius.circular(radius));
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
