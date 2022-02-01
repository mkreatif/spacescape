import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:spacescape/game/enemy.dart';
import 'package:spacescape/game/spacescapegame.dart';

class Bullet extends SpriteComponent
    with HasHitboxes, Collidable, HasGameRef<SpacescapeGame> {
  final double speed;
  Bullet({Sprite? sprite, Vector2? position, Vector2? size, this.speed = 450})
      : super(sprite: sprite, position: position, size: size) {
    final shape = HitboxCircle(normalizedRadius: 0.2);
    addHitbox(shape);
  }
  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if (other is Enemy) {
      gameRef.remove(this);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += Vector2(0, -1) * speed * dt;
    if (position.y < 0) {
      remove(this);
    }
  }
}
