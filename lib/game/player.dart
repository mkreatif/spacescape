import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:spacescape/game/enemy.dart';
import 'package:spacescape/game/know_game_size.dart';
import 'package:spacescape/game/spacescapegame.dart';

class Player extends SpriteComponent
    with KnowGameSize, HasHitboxes, Collidable, HasGameRef<SpacescapeGame> {
  final JoystickComponent joystick;
  Vector2 _moveDirection = Vector2.zero();
  final double _speed = 300;
  final List<Color> _colors = [Colors.red, Colors.orange, Colors.yellow];

  final Random _random = Random();

  Player(this.joystick, {Sprite? sprite, Vector2? position, Vector2? size})
      : super(sprite: sprite, position: position, size: size);

  Vector2 getRandomVector() =>
      (Vector2.random(_random) - Vector2(0.5, -1)) * 200;

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

  void setMoveDirection(Vector2 newMoveDirection, double dt) {
    _moveDirection = newMoveDirection;
    position += _moveDirection.normalized() * _speed * dt;
    position.clamp(Vector2.zero() + size / 2, gameSize - size / 2);
  }

  @override
  void update(double dt) {
    super.update(dt);
    switch (joystick.direction) {
      case JoystickDirection.up:
        setMoveDirection(Vector2(0, -1), dt);
        break;
      case JoystickDirection.upLeft:
        setMoveDirection(Vector2(-1, -1), dt);
        break;
      case JoystickDirection.upRight:
        setMoveDirection(Vector2(1, -1), dt);
        break;
      case JoystickDirection.right:
        setMoveDirection(Vector2(1, 0), dt);
        break;
      case JoystickDirection.down:
        setMoveDirection(Vector2(0, 1), dt);
        break;
      case JoystickDirection.downRight:
        setMoveDirection(Vector2(1, 1), dt);
        break;
      case JoystickDirection.downLeft:
        setMoveDirection(Vector2(-1, 1), dt);
        break;
      case JoystickDirection.left:
        setMoveDirection(Vector2(-1, 0), dt);
        break;
      case JoystickDirection.idle:
        break;
      default:
    }

    final _particle = ParticleComponent(
      Particle.generate(
        count: 10,
        lifespan: 0.1,
        generator: (i) => AcceleratedParticle(
          acceleration: getRandomVector(),
          speed: getRandomVector(),
          position: position + Vector2(0, size.y / 4),
          child: CircleParticle(
              paint: Paint()..color = _colors[_random.nextInt(20) % 3],
              radius: 1),
        ),
      ),
    );
    gameRef.add(_particle);
  }
}
