
import 'dart:ui';

class Stroke {
  Stroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
    this.roomId = 'default',
  });

  final List<Offset> points;
  final int color; // ARGB int
  final double strokeWidth;
  final String roomId;

  Map<String, dynamic> toJson() => {
        'type': 'stroke',
        'payload': {
          'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
          'color': color,
          'strokeWidth': strokeWidth,
          'roomId': roomId,
        }
      };

  static Stroke fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] ?? json;
    final pts = (payload['points'] as List)
        .map((m) => Offset((m['x'] as num).toDouble(), (m['y'] as num).toDouble()))
        .toList();
    return Stroke(
      points: pts,
      color: payload['color'] as int,
      strokeWidth: (payload['strokeWidth'] as num).toDouble(),
      roomId: (payload['roomId'] as String?) ?? 'default',
    );
  }
}
