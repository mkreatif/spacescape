import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/rendering.dart';
import 'package:spacescape/game/enemy.dart';
import 'package:spacescape/game/know_game_size.dart';
import 'package:spacescape/game/spacescapegame.dart';

class Player extends SpriteComponent
    with KnowGameSize, HasHitboxes, Collidable, HasGameRef<SpacescapeGame> {
  Vector2 _moveDirection = Vector2.zero();
  final double _speed = 300;
  Player({Sprite? sprite, Vector2? position, Vector2? size})
      : super(sprite: sprite, position: position, size: size);

  @override
  void onMount() {
    super.onMount();
    final shape = HitboxCircle(normalizedRadius: 0.8);
    addHitbox(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if (other is Enemy) {}
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _moveDirection.normalized() * _speed * dt;
    position.clamp(Vector2.zero() + size / 2, gameSize - size / 2);
  }

  void setMoveDirection(Vector2 newMoveDirection) {
    _moveDirection = newMoveDirection;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    renderHitboxes(canvas);
  }
}
