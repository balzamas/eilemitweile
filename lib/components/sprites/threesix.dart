import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import '../../eilemitweile_game.dart';
import 'package:flutter/widgets.dart';

class ThreeSix extends PositionComponent
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  bool get debugMode => false;

  static late final Sprite threesixSprite = emwSprite(0, 1393, 810, 710);

  @override
  void render(Canvas canvas) {
    threesixSprite.render(canvas,
        position: Vector2(0, 0), anchor: Anchor.center);
  }
}
