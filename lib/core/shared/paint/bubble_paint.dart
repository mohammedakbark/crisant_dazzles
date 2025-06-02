import 'dart:math';

import 'package:flutter/material.dart';

class BubblePainter extends CustomPainter {
  final Animation<double> animation;
  final List<Bubble> bubbles = [];
  final int maxBubbles = 12; // 👈 Reduced count
  final Random rand = Random();

  BubblePainter({required this.animation}) : super(repaint: animation) {
    _generateBubbles();
  }

  void _generateBubbles() {
    for (int i = 0; i < maxBubbles; i++) {
      bubbles.add(_createBubble());
    }
  }

  Bubble _createBubble({bool randomX = true}) {
  final radius = rand.nextDouble() * 10 + 4;
  final x = randomX ? rand.nextDouble() * 300 : rand.nextDouble() * 30;
  final y = rand.nextDouble() * 60 + 10;
  final speed = rand.nextDouble() * 0.25 + 0.15;
  final opacity = rand.nextDouble() * 0.4 + 0.3;
  final verticalOffset = rand.nextDouble() * 5;
  final wobblePhase = rand.nextDouble() * pi * 2;

  return Bubble(
    position: Offset(x, y),
    radius: radius,
    speed: speed,
    opacity: opacity,
    verticalOffset: verticalOffset,
    wobblePhase: wobblePhase,
  );
}

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final time = animation.value * 2 * pi;

    for (int i = 0; i < bubbles.length; i++) {
      Bubble bubble = bubbles[i];

      double dx = bubble.position.dx + bubble.speed; // 👈 Slower drift
      if (dx > size.width + 20) {
        bubbles[i] = _createBubble(); // recycle bubble
        continue;
      }

      double dy = bubble.position.dy + sin(time + bubble.wobblePhase) * bubble.verticalOffset;

      paint.color = Colors.blue.withOpacity(bubble.opacity);
      canvas.drawCircle(Offset(dx, dy), bubble.radius, paint);

      bubble.position = Offset(dx, bubble.position.dy);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}




class Bubble {
  Offset position;
  double radius;
  double speed;
  double opacity;
  double verticalOffset;
  double wobblePhase;

  Bubble({
    required this.position,
    required this.radius,
    required this.speed,
    required this.opacity,
    required this.verticalOffset,
    required this.wobblePhase,
  });
}
