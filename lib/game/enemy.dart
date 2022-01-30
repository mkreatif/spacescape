import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:spacescape/game/know_game_size.dart';

class Enemy extends SpriteComponent with KnowGameSize {
  double _speed = 250;
  Enemy({Sprite? sprite, Vector2? position, Vector2? size})
      : super(sprite: sprite, position: position, size: size);

  @override
  void update(double dt) {
    super.update(dt);
    position += Vector2(0, 1) * _speed * dt;
    if (position.y > gameSize.y) {
      remove(this);
    }
  }

  @override
  void onRemove() {
    super.onRemove();
    debugPrint("REMOVING ${toString()}");
  }
}
