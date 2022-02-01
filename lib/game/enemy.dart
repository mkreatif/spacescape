import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:spacescape/game/bullet.dart';
import 'package:spacescape/game/know_game_size.dart';
import 'package:spacescape/game/spacescapegame.dart';

class Enemy extends SpriteComponent
    with KnowGameSize, HasHitboxes, Collidable, HasGameRef<SpacescapeGame> {
  final double _speed = 250;
  final List<Color> _colors = [
    Colors.red,
    Colors.white,
    Colors.yellow,
    Colors.orange
  ];

  final Random _random = Random();
  Enemy({Sprite? sprite, Vector2? position, Vector2? size})
      : super(sprite: sprite, position: position, size: size) {
    angle = pi;
  }

  Vector2 getRandomVector() =>
      (Vector2.random(_random) - Vector2.random(_random)) * 500;

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
      final _particle = ParticleComponent(
        Particle.generate(
          count: 20,
          lifespan: 0.1,
          generator: (i) => AcceleratedParticle(
            acceleration: getRandomVector(),
            speed: getRandomVector(),
            position: position + Vector2(0, size.y / 5),
            child: CircleParticle(
                paint: Paint()..color = _colors[_random.nextInt(20) % 4],
                radius: 1.5),
          ),
        ),
      );
      gameRef.add(_particle);
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
