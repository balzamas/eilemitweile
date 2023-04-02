import 'dart:ui';

import 'package:EileMitWeile/components/player.dart';
import 'package:EileMitWeile/components/token.dart';
import 'package:flame/components.dart';
import '../../eilemitweile_game.dart';

class HomeField extends PositionComponent with HasGameRef<EileMitWeileGame> {
  late Player player;
  List<Token> tokens = [];

  @override
  bool get debugMode => false;

  static late final Sprite homefield_red = emwSprite(0, 101, 200, 198);
  static late final Sprite homefield_blue = emwSprite(200, 101, 200, 198);
  static late final Sprite homefield_green = emwSprite(400, 101, 200, 198);
  static late final Sprite homefield_yellow = emwSprite(600, 101, 200, 198);

  @override
  void render(Canvas canvas) {
    if (player.color == 1)
      homefield_red.render(canvas,
          position: Vector2(0, 0),
          anchor: Anchor.topLeft,
          size: Vector2(130, 130));
    else if (player.color == 2)
      homefield_blue.render(canvas,
          position: Vector2(0, 0),
          anchor: Anchor.topLeft,
          size: Vector2(130, 130));
    else if (player.color == 3)
      homefield_green.render(canvas,
          position: Vector2(0, 0),
          anchor: Anchor.topLeft,
          size: Vector2(130, 130));
    else
      homefield_yellow.render(canvas,
          position: Vector2(0, 0),
          anchor: Anchor.topLeft,
          size: Vector2(130, 130));
  }
}
