import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:spacescape/game/enemy.dart';
import 'package:spacescape/game/know_game_size.dart';
import 'package:spacescape/game/spacescapegame.dart';

class EnemyManager extends Component
    with KnowGameSize, HasGameRef<SpacescapeGame> {
  late Timer timer;
  SpriteSheet spriteSheet;
  final Random _enemySpawnRandom = Random();
  EnemyManager({required this.spriteSheet}) : super() {
    timer = Timer(1, onTick: _spawnEnemy, repeat: true);
  }

  void _spawnEnemy() {
    Vector2 initSize = Vector2(64, 64);
    Vector2 position = Vector2(_enemySpawnRandom.nextDouble() * gameSize.x, 0);
    position.clamp(Vector2.zero() + initSize / 2, gameSize - initSize / 2);
    Enemy enemy = Enemy(
        sprite: spriteSheet.getSpriteById(12),
        size: initSize,
        position: position);
    enemy.anchor = Anchor.center;
    add(enemy);
  }

  @override
  void onMount() {
    super.onMount();
    timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
  }
}
