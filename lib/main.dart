import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:spacescape/game/spacescapegame.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Flame.device.fullScreen();
  runApp(GameWidget(game: SpacescapeGame()));
}
