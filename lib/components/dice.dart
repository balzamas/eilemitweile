import 'dart:math';
import 'dart:ui';

import 'package:EileMitWeile/components/tokens.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';

import '../eilemitweile_game.dart';
import 'package:flutter/widgets.dart';

import '../enums.dart';
import 'movement.dart';

class Dice extends PositionComponent
    with TapCallbacks, HasGameRef<EilemitweileGame> {
  @override
  bool get debugMode => false;

  static late final Sprite diceSprite = emwSprite(0, 651, 399, 399);

  @override
  void render(Canvas canvas) {
    diceSprite.render(canvas, position: Vector2(0, 0), anchor: Anchor.topLeft);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (!gameRef.current_player!.is_AI) {
      ThrowDice(gameRef);
    }
  }
}
