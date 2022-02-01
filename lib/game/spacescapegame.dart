import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:spacescape/game/bullet.dart';
import 'package:spacescape/game/enemy_manager.dart';
import 'package:spacescape/game/player.dart';

class SpacescapeGame extends FlameGame
    with HasCollidables, HasDraggables, HasTappables {
  late Player player;
  late SpriteSheet _spriteSheet;
  late EnemyManager _enemyManager;

  final Map<int, String> _assetsPath = {
    0: 'tilesheet.png',
    1: 'SmallHandleFilled.png',
    2: 'LargeHandleFilledGrey.png'
  };

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    for (var path in _assetsPath.values) {
      await images.load(path);
    }
    _spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache(_assetsPath[0].toString()),
        columns: 8,
        rows: 6);
    final knob = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache(_assetsPath[1].toString()),
        columns: 1,
        rows: 1);
    final bgKnob = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache(_assetsPath[2].toString()),
        columns: 1,
        rows: 1);

    _enemyManager = EnemyManager(spriteSheet: _spriteSheet);

    JoystickComponent joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: knob.getSpriteById(0),
        size: Vector2.all(40),
      ),
      background: SpriteComponent(
        sprite: bgKnob.getSpriteById(0),
        size: Vector2.all(100),
      ),
      margin: const EdgeInsets.only(left: 50, bottom: 50),
    );
    player = Player(joystick,
        sprite: _spriteSheet.getSpriteById(6),
        size: Vector2(64, 64),
        position: canvasSize / 2);
    player.anchor = Anchor.center;
    SpriteButtonComponent action = SpriteButtonComponent(
        button: knob.getSpriteById(0),
        buttonDown: bgKnob.getSpriteById(0),
        size: Vector2.all(100),
        position: Vector2(canvasSize.x - 100, canvasSize.y - 100),
        anchor: Anchor.center,
        onPressed: () {
          Bullet bullet = Bullet(
              sprite: _spriteSheet.getSpriteById(28),
              size: Vector2(64, 64),
              position: player.position);

          bullet.anchor = Anchor.center;
          add(bullet);
        });
    add(player);
    add(_enemyManager);
    add(joystick);
    add(action);
  }
}
