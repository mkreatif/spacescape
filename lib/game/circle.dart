import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Circle extends PositionComponent {
  late Paint _paint;
  final double radius;
  final Color color;
  Circle({this.radius = 20, this.color = Colors.white}) {
    _paint = Paint()..color = color;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Vector2(0, 0).toOffset(), radius, _paint);
  }
}
