import 'dart:ui';

import 'package:EileMitWeile/components/token.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import '../../eilemitweile_game.dart';
import 'package:flutter/widgets.dart';

import '../gamelogic.dart';

class MoveButton extends PositionComponent
    with TapCallbacks, HasPaint, HasGameRef<EileMitWeileGame> {
  int button_number = 0;

  @override
  bool get debugMode => false;

  static late final Sprite movebuttonSprite1 = emwSprite(0, 300, 332, 332);
  static late final Sprite movebuttonSprite2 = emwSprite(332, 300, 332, 332);
  static late final Sprite movebuttonSprite3 = emwSprite(664, 300, 332, 332);
  static late final Sprite movebuttonSprite4 = emwSprite(996, 300, 332, 332);

  @override
  void render(Canvas canvas) {
    if (button_number == 0) {
      movebuttonSprite1.render(canvas,
          position: Vector2(0, 0), anchor: Anchor.topLeft);
    } else if (button_number == 1) {
      movebuttonSprite2.render(canvas,
          position: Vector2(0, 0), anchor: Anchor.topLeft);
    } else if (button_number == 2) {
      movebuttonSprite3.render(canvas,
          position: Vector2(0, 0), anchor: Anchor.topLeft);
    } else if (button_number == 3) {
      movebuttonSprite4.render(canvas,
          position: Vector2(0, 0), anchor: Anchor.topLeft);
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    Token token = gameRef.current_player!.tokens[this.button_number];

    if (!gameRef.current_player!.is_AI &&
        gameRef.current_player == token.player &&
        token.can_move) {
      Move(gameRef, token, gameRef.thrown_dices[0]);
      token.MoveSprite();
      if (gameRef.thrown_dices.length == 0 ||
          CheckTokensToMove(gameRef, gameRef.thrown_dices[0]) == false) {
        gameRef.NextPlayer();
      }
    }
  }
}
