import 'package:flame/components.dart';
import 'package:spacescape/game/know_game_size.dart';

class Player extends SpriteComponent with KnowGameSize {
  Vector2 _moveDirection = Vector2.zero();
  final double _speed = 300;
  Player({Sprite? sprite, Vector2? position, Vector2? size})
      : super(sprite: sprite, position: position, size: size);

  @override
  void update(double dt) {
    super.update(dt);
    position += _moveDirection.normalized() * _speed * dt;
    position.clamp(Vector2.zero() + size / 2, gameSize - size / 2);
  }

  void setMoveDirection(Vector2 newMoveDirection) {
    _moveDirection = newMoveDirection;
  }
}
