import 'dart:ui';

import 'package:flame/components.dart';

import '../../eilemitweile_game.dart';
import 'package:flutter/widgets.dart';

class Heaven extends PositionComponent {
  @override
  bool get debugMode => false;

  static late final Sprite heavenSprite = emwSprite(0, 785, 600, 600);

  @override
  void render(Canvas canvas) {
    heavenSprite.render(canvas,
        position: Vector2(0, 0), anchor: Anchor.topLeft);
  }
}
