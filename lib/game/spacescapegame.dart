import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:spacescape/game/bullet.dart';
import 'package:spacescape/game/enemy_manager.dart';
import 'package:spacescape/game/know_game_size.dart';
import 'package:spacescape/game/player.dart';

class SpacescapeGame extends FlameGame
    with PanDetector, TapDetector, HasCollidables {
  late Player player;
  Offset? _pointerStartPosition;
  Offset? _pointerCurrentPosition;
  final double _joysticRadius = 60, _deadZoneRadius = 10;
  late SpriteSheet _spriteSheet;
  late EnemyManager _enemyManager;

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    await images.load('tilesheet.png');
    _spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('tilesheet.png'), columns: 8, rows: 6);
    player = Player(
        sprite: _spriteSheet.getSpriteById(6),
        size: Vector2(64, 64),
        position: canvasSize / 2);

    player.anchor = Anchor.center;
    add(player);
    _enemyManager = EnemyManager(spriteSheet: _spriteSheet);
    add(_enemyManager);
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

  // @override
  // void update(double dt) {
  //   super.update(dt);

  //   final bullets = children.whereType<Bullet>();
  //   for (var enemy in _enemyManager.children.whereType<Enemy>()) {
  //     if (enemy.shouldRemove) {
  //       continue;
  //     }
  //     for (var bullet in bullets) {
  //       if (bullet.shouldRemove) {
  //         continue;
  //       }
  //       if (enemy.containsPoint(bullet.absoluteCenter)) {
  //         _enemyManager.remove(enemy);
  //         remove(bullet);
  //         break;
  //       }
  //     }

  //     if (player.containsPoint(enemy.absoluteCenter)) {
  //       _enemyManager.remove(enemy);
  //     }
  //   }
  // }

  @override
  void onPanStart(DragStartInfo info) {
    _pointerStartPosition = info.eventPosition.global.toOffset();
    _pointerCurrentPosition = info.eventPosition.global.toOffset();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
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
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;
    player.setMoveDirection(Vector2.zero());
  }

  @override
  void onPanCancel() {
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

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    Bullet bullet = Bullet(
        sprite: _spriteSheet.getSpriteById(28),
        size: Vector2(64, 64),
        position: player.position);

    bullet.anchor = Anchor.center;
    add(bullet);
  }
}
