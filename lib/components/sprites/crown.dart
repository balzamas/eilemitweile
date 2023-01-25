import 'dart:ui';

import 'package:flame/components.dart';

import '../../eilemitweile_game.dart';
import 'package:flutter/widgets.dart';

class Crown extends PositionComponent {
  @override
  bool get debugMode => false;

  static late final Sprite crownSprite = emwSprite(1120, 0, 39, 50);

  @override
  void render(Canvas canvas) {
    crownSprite.render(canvas,
        position: Vector2(10, 0), anchor: Anchor.topLeft);
  }
}
