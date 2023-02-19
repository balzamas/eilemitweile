import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import '../../eilemitweile_game.dart';
import 'package:flutter/widgets.dart';

import '../gamelogic.dart';

class Heaven extends PositionComponent
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  bool get debugMode => false;

  static late final Sprite heavenSprite = emwSprite(0, 785, 600, 600);

  @override
  void render(Canvas canvas) {
    heavenSprite.render(canvas,
        position: Vector2(0, 0), anchor: Anchor.topLeft);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (!gameRef.current_player!.is_AI && gameRef.can_throw_dice) {
      if (ThrowDice(gameRef)) {
        gameRef.NextPlayer();
      } else if (!gameRef.can_throw_dice) {
        int dices = gameRef.thrown_dices.length;
        for (var i = 0; i < dices; i++) {
          if (CheckTokensToMove(gameRef, gameRef.thrown_dices[0]) == false) {
            gameRef.thrown_dices.removeAt(0);
          }
          gameRef.dice_text.text = gameRef.thrown_dices.join(" ");
        }
      }
    }
  }
}
