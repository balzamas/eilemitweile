import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import '../../eilemitweile_game.dart';
import 'package:flutter/widgets.dart';

class Paeng extends PositionComponent
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  bool get debugMode => false;

  static late final Sprite paengSprite = emwSprite(1002, 0, 120, 90);

  @override
  void render(Canvas canvas) {
    paengSprite.render(canvas, position: Vector2(0, 0), anchor: Anchor.center);
  }
}
