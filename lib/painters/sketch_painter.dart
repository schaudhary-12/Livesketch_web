
import 'package:flutter/material.dart';
import '../models/stroke.dart';

class SketchPainter extends CustomPainter {
  SketchPainter(this.strokes, this.current);

  final List<Stroke> strokes;
  final Stroke? current;

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in [...strokes, if (current != null) current!]) {
      if (s.points.isEmpty) continue;
      final paint = Paint()
        ..color = Color(s.color)
        ..strokeWidth = s.strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final path = Path()..moveTo(s.points.first.dx, s.points.first.dy);
      for (int i = 1; i < s.points.length; i++) {
        path.lineTo(s.points[i].dx, s.points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SketchPainter oldDelegate) {
    return oldDelegate.strokes != strokes || oldDelegate.current != current;
  }
}
