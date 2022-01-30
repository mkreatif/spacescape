import 'package:flame/components.dart';

mixin KnowGameSize on Component {
  late Vector2 gameSize;
  @override
  void onGameResize(Vector2 newGameSize) {
    super.onGameResize(newGameSize);
    gameSize = newGameSize;
  }
}
