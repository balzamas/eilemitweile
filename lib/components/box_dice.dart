import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';

import '../eilemitweile_game.dart';
import 'gamelogic.dart';

class BoxDice extends PositionComponent
    with TapCallbacks, OpacityProvider, HasGameRef<EileMitWeileGame> {
  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    size = Vector2(EileMitWeileGame.info_col_size, gameRef.screenHeight);

    return super.onLoad();
  }

  @override
  bool get debugMode => false;

  @override
  late double opacity;

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
            game.dices_gfx[0].removeFromParent();
            game.dices_gfx.removeAt(0);
            PaintDices(game);
          }
        }
      }
    }
  }
}
