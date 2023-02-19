import 'package:EileMitWeile/eilemitweile_game.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';

import '../gamelogic.dart';
import '../token.dart';

/// A simple sprite component that pauses the game when tapped.
class ButtonComponent extends SpriteComponent
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  int button_number = 0;

  /// Position to show the button.
  ButtonComponent({
    required Vector2 position,
    required Sprite sprite,
  }) : super(position: position, size: Vector2(332, 332), sprite: sprite);

  @override
  Future<void> onLoad() async {}

  @override
  void onTapUp(TapUpEvent event) {
    Token token = gameRef.current_player!.tokens[this.button_number];

    if (!gameRef.current_player!.is_AI &&
        gameRef.current_player == token.player &&
        !gameRef.can_throw_dice &&
        token.can_move) {
      token.can_move = false;
      Move(gameRef, token, gameRef.thrown_dices[0]);
      token.MoveSprite();
      if (gameRef.thrown_dices.length == 2 &&
          CheckTokensToMove(gameRef, gameRef.thrown_dices[0]) == false) {
        game.thrown_dices.removeAt(0);
        game.dice_text.text = game.thrown_dices.join(" ");
      }
      if (gameRef.thrown_dices.length == 0 ||
          CheckTokensToMove(gameRef, gameRef.thrown_dices[0]) == false) {
        gameRef.NextPlayer();
      }
    }
  }

  void setPlayerColor(int color) {
    late Sprite the_sprite;

    if (color == 1) {
      if (this.button_number == 0) {
        the_sprite = emwSprite(1150, 0, 332, 332);
      } else if (this.button_number == 1) {
        the_sprite = emwSprite(1482, 0, 332, 332);
      } else if (this.button_number == 2) {
        the_sprite = emwSprite(1814, 0, 332, 332);
      } else if (this.button_number == 3) {
        the_sprite = emwSprite(2146, 0, 332, 332);
      }
    } else if (color == 2) {
      if (this.button_number == 0) {
        the_sprite = emwSprite(1150, 332, 332, 332);
      } else if (this.button_number == 1) {
        the_sprite = emwSprite(1482, 332, 332, 332);
      } else if (this.button_number == 2) {
        the_sprite = emwSprite(1814, 332, 332, 332);
      } else if (this.button_number == 3) {
        the_sprite = emwSprite(2146, 332, 332, 332);
      }
    } else if (color == 3) {
      if (this.button_number == 0) {
        the_sprite = emwSprite(1150, 664, 332, 332);
      } else if (this.button_number == 1) {
        the_sprite = emwSprite(1482, 664, 332, 332);
      } else if (this.button_number == 2) {
        the_sprite = emwSprite(1814, 664, 332, 332);
      } else if (this.button_number == 3) {
        the_sprite = emwSprite(2146, 664, 332, 332);
      }
    } else if (color == 4) {
      if (this.button_number == 0) {
        the_sprite = emwSprite(1150, 996, 332, 332);
      } else if (this.button_number == 1) {
        the_sprite = emwSprite(1482, 996, 332, 332);
      } else if (this.button_number == 2) {
        the_sprite = emwSprite(1814, 996, 332, 332);
      } else if (this.button_number == 3) {
        the_sprite = emwSprite(2146, 996, 332, 332);
      }
    }

    this.sprite = the_sprite;
  }
}
