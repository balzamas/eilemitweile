import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import '../../eilemitweile_game.dart';
import 'package:flutter/widgets.dart';

class Victory extends PositionComponent
    with TapCallbacks, HasGameRef<EilemitweileGame> {
  @override
  bool get debugMode => false;

  static late final Sprite victorySprite = emwSprite(1461, 1042, 918, 700);

  @override
  void render(Canvas canvas) {
    victorySprite.render(canvas,
        position: Vector2(0, 0), anchor: Anchor.center);
  }
}
