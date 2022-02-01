import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:spacescape/game/bullet.dart';
import 'package:spacescape/game/know_game_size.dart';
import 'package:spacescape/game/spacescapegame.dart';

class Enemy extends SpriteComponent
    with KnowGameSize, HasHitboxes, Collidable, HasGameRef<SpacescapeGame> {
  final double _speed = 250;
  Enemy({Sprite? sprite, Vector2? position, Vector2? size})
      : super(sprite: sprite, position: position, size: size) {
    angle = pi;
  }

  @override
  void onMount() {
    super.onMount();
    final shape = HitboxCircle(normalizedRadius: 0.8);
    addHitbox(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if (other is Bullet) {
      gameRef.remove(this);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += Vector2(0, 1) * _speed * dt;
    if (position.y > gameSize.y) {
      remove(this);
    }
  }
}
