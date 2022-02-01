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
  late TextComponent _playerScore, _playerHealt;

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

    final joystick = JoystickComponent(
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
    final action = SpriteButtonComponent(
        button: knob.getSpriteById(0),
        buttonDown: bgKnob.getSpriteById(0),
        size: Vector2.all(70),
        position: Vector2(canvasSize.x - 75, canvasSize.y - 100),
        anchor: Anchor.center,
        onPressed: () {
          Bullet bullet = Bullet(
              sprite: _spriteSheet.getSpriteById(28),
              size: Vector2(64, 64),
              position: player.position);

          bullet.anchor = Anchor.center;
          add(bullet);
        });

    _playerScore = TextComponent(
        text: 'Score : 0',
        position: Vector2(20, 20),
        anchor: Anchor.topLeft,
        textRenderer: TextPaint(
            style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold)));

    _playerHealt = TextComponent(
        text: 'Healt : 100%',
        position: Vector2(size.x - 20, 20),
        anchor: Anchor.topRight,
        textRenderer: TextPaint(
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)));
    _playerHealt.positionType = PositionType.widget;
    _playerScore.positionType = PositionType.viewport;
    action.positionType = PositionType.viewport;

    add(player);
    add(_enemyManager);
    add(joystick);
    add(action);
    add(_playerScore);
    add(_playerHealt);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _playerHealt.text = "Healt : ${player.healt}%";
    _playerScore.text = "Score : ${player.score}";
  }

  @override
  void render(Canvas canvas) {
    Color _color;
    if (player.healt >= 70) {
      _color = Colors.green;
    } else if (player.healt < 70 && player.healt >= 40) {
      _color = Colors.yellow;
    } else {
      _color = Colors.red;
    }

    canvas.drawRect(
        Rect.fromLTWH(size.x - 110, 15, player.healt.toDouble(), 25),
        Paint()..color = _color);
    super.render(canvas);
  }
}
