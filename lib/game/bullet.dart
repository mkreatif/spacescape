import 'package:flame/components.dart';

class Bullet extends SpriteComponent {
  final double speed;
  Bullet({Sprite? sprite, Vector2? position, Vector2? size, this.speed = 450})
      : super(sprite: sprite, position: position, size: size);
  @override
  void update(double dt) {
    super.update(dt);
    position += Vector2(0, -1) * speed * dt;
    if (position.y < 0) {
      remove(this);
    }
  }
}
