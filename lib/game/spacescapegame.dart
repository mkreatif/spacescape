import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class SpacescapeGame extends FlameGame {
  @override
  Future<void>? onLoad() async {
    super.onLoad();
    await images.load('tilesheet.png');
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('tilesheet.png'), columns: 8, rows: 6);
    SpriteComponent player = SpriteComponent(
        sprite: spriteSheet.getSpriteById(6),
        size: Vector2(64, 64),
        position: canvasSize / 2);
    player.anchor = Anchor.center;
    add(player);
  }
}
