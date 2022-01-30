import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:spacescape/game/enemy.dart';
import 'package:spacescape/game/enemy_manager.dart';
import 'package:spacescape/game/know_game_size.dart';
import 'package:spacescape/game/player.dart';

class SpacescapeGame extends FlameGame with PanDetector {
  late Player player;
  Offset? _pointerStartPosition;
  Offset? _pointerCurrentPosition;
  final double _joysticRadius = 60, _deadZoneRadius = 10;

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    await images.load('tilesheet.png');
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('tilesheet.png'), columns: 8, rows: 6);
    player = Player(
        sprite: spriteSheet.getSpriteById(6),
        size: Vector2(64, 64),
        position: canvasSize / 2);

    player.anchor = Anchor.center;
    add(player);
    EnemyManager enemyManager = EnemyManager(spriteSheet: spriteSheet);
    add(enemyManager);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // render joystic
    if (_pointerStartPosition != null) {
      canvas.drawCircle(_pointerStartPosition!, _joysticRadius,
          Paint()..color = Colors.grey.withAlpha(100));
    }
    // render joystic pointer
    if (_pointerCurrentPosition != null) {
      var delta = _pointerCurrentPosition! - _pointerStartPosition!;

      if (delta.distance > _joysticRadius) {
        Vector2 vektor = Vector2(delta.dx, delta.dy);
        final normalize = vektor.normalized() * _joysticRadius;
        delta = _pointerStartPosition! + normalize.toOffset();
      } else {
        delta = _pointerCurrentPosition!;
      }
      canvas.drawCircle(
          delta, 20, Paint()..color = Colors.white.withAlpha(100));
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    debugPrint('on pan start');
    _pointerStartPosition = info.eventPosition.global.toOffset();
    _pointerCurrentPosition = info.eventPosition.global.toOffset();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    debugPrint('on pan update');
    _pointerCurrentPosition = info.eventPosition.global.toOffset();
    final delta = _pointerCurrentPosition! - _pointerStartPosition!;
    if (delta.distance > _deadZoneRadius) {
      player.setMoveDirection(Vector2(delta.dx, delta.dy));
    } else {
      player.setMoveDirection(Vector2.zero());
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    debugPrint('on pan end');
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;
    player.setMoveDirection(Vector2.zero());
  }

  @override
  void onPanCancel() {
    debugPrint('on pan cancel');
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;

    player.setMoveDirection(Vector2.zero());
  }

  @override
  void prepare(Component parent) {
    super.prepare(parent);
    if (parent is KnowGameSize) {
      parent.onGameResize(size);
    }
  }
}
