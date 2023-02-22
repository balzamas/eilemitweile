import 'dart:ui';

import 'package:EileMitWeile/components/gamelogic.dart';
import 'package:EileMitWeile/components/sprites/paeng.dart';
import 'package:EileMitWeile/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';

import '../eilemitweile_game.dart';
import 'field.dart';

class Token extends PositionComponent
    with TapCallbacks, HasPaint, OpacityProvider, HasGameRef<EileMitWeileGame> {
  bool can_move = false;
  int last_round_moved = 0;
  int cur_tile = 0;
  int token_number = 0;
  late Player player;
  Field? field;
  int bodycount = 0;
  Token(Player player) {
    this.player = player;
  }

  @override
  bool get debugMode => false;

  static late final Sprite tokenSprite_red_1 = emwSprite(602, 0, 50, 50);
  static late final Sprite tokenSprite_red_2 = emwSprite(652, 0, 50, 50);
  static late final Sprite tokenSprite_red_3 = emwSprite(603, 50, 50, 50);
  static late final Sprite tokenSprite_red_4 = emwSprite(652, 50, 50, 50);

  static late final Sprite tokenSprite_blue_1 = emwSprite(702, 0, 50, 50);
  static late final Sprite tokenSprite_blue_2 = emwSprite(752, 0, 50, 50);
  static late final Sprite tokenSprite_blue_3 = emwSprite(702, 50, 50, 50);
  static late final Sprite tokenSprite_blue_4 = emwSprite(752, 50, 50, 50);

  static late final Sprite tokenSprite_green_1 = emwSprite(802, 0, 50, 50);
  static late final Sprite tokenSprite_green_2 = emwSprite(852, 0, 50, 50);
  static late final Sprite tokenSprite_green_3 = emwSprite(802, 50, 50, 50);
  static late final Sprite tokenSprite_green_4 = emwSprite(852, 50, 50, 50);

  static late final Sprite tokenSprite_yellow_1 = emwSprite(902, 0, 50, 50);
  static late final Sprite tokenSprite_yellow_2 = emwSprite(952, 0, 50, 50);
  static late final Sprite tokenSprite_yellow_3 = emwSprite(902, 50, 50, 50);
  static late final Sprite tokenSprite_yellow_4 = emwSprite(952, 50, 50, 50);

  @override
  void render(Canvas canvas) {
    if (player.color == 1) {
      if (token_number == 0) {
        tokenSprite_red_1.render(canvas,
            position: Vector2(0, 0), anchor: Anchor.topLeft);
      } else if (token_number == 1) {
        tokenSprite_red_2.render(canvas,
            position: Vector2(0, 0), anchor: Anchor.topLeft);
      } else if (token_number == 2) {
        tokenSprite_red_3.render(canvas,
            position: Vector2(0, 0), anchor: Anchor.topLeft);
      } else if (token_number == 3) {
        tokenSprite_red_4.render(canvas,
            position: Vector2(0, 0), anchor: Anchor.topLeft);
      }
    } else if (player.color == 2) {
      if (token_number == 0) {
        tokenSprite_blue_1.render(canvas,
            position: Vector2(0, 0), anchor: Anchor.topLeft);
      } else if (token_number == 1) {
        tokenSprite_blue_2.render(canvas,
            position: Vector2(0, 0), anchor: Anchor.topLeft);
      } else if (token_number == 2) {
        tokenSprite_blue_3.render(canvas,
            position: Vector2(0, 0), anchor: Anchor.topLeft);
      } else if (token_number == 3) {
        tokenSprite_blue_4.render(canvas,
            position: Vector2(0, 0), anchor: Anchor.topLeft);
      }
    } else if (player.color == 3) {
      if (token_number == 0) {
        tokenSprite_green_1.render(canvas,
            position: Vector2(0, 0), anchor: Anchor.topLeft);
      } else if (token_number == 1) {
        tokenSprite_green_2.render(canvas,
            position: Vector2(0, 0), anchor: Anchor.topLeft);
      } else if (token_number == 2) {
        tokenSprite_green_3.render(canvas,
            position: Vector2(0, 0), anchor: Anchor.topLeft);
      } else if (token_number == 3) {
        tokenSprite_green_4.render(canvas,
            position: Vector2(0, 0), anchor: Anchor.topLeft);
      }
    } else if (player.color == 4) {
      if (token_number == 0) {
        tokenSprite_yellow_1.render(canvas,
            position: Vector2(0, 0), anchor: Anchor.topLeft);
      } else if (token_number == 1) {
        tokenSprite_yellow_2.render(canvas,
            position: Vector2(0, 0), anchor: Anchor.topLeft);
      } else if (token_number == 2) {
        tokenSprite_yellow_3.render(canvas,
            position: Vector2(0, 0), anchor: Anchor.topLeft);
      } else if (token_number == 3) {
        tokenSprite_yellow_4.render(canvas,
            position: Vector2(0, 0), anchor: Anchor.topLeft);
      }
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (!gameRef.current_player!.is_AI &&
        gameRef.current_player == this.player &&
        this.can_move) {
      Move(gameRef, this, gameRef.thrown_dices[0]);
      this.MoveSprite();
      if (gameRef.thrown_dices.length == 2 &&
          CheckTokensToMove(gameRef, gameRef.thrown_dices[0]) == false) {
        game.thrown_dices.removeAt(0);
        game.dices_gfx[0].removeFromParent();
        game.dices_gfx.removeAt(0);
      }
      if (gameRef.thrown_dices.length == 0 ||
          CheckTokensToMove(gameRef, gameRef.thrown_dices[0]) == false) {
        gameRef.NextPlayer();
      }
    }
  }

  void MoveSprite() {
    this.add(
      MoveEffect.to(
        this.field!.getTokenPosition(this),
        EffectController(duration: 0.5),
      ),
    );
  }

  void SendHome(start_field, end_field) {
    for (var i = start_field + 1; i < end_field; i++) {
      if (gameRef.fields[i].tokens.length > 0) {
        gameRef.fields[i].sendHomeTokens(this.player);
      }
    }
  }

  void SendMeHome() {
    Paeng paeng = Paeng();
    paeng.position = Vector2(this.position.x + 25, this.y + 25);
    //paeng.angle = pi / 3;
    gameRef.world.add(paeng);
    paeng.add(RemoveEffect(delay: 1.0));

    this.field!.tokens.remove(this);
    this.field?.rearrangeTokens();
    this.field = game.fields[0];
    this.field!.tokens.add(this);
    this.add(
      MoveEffect.to(
        gameRef.fields[0].getTokenPosition(this),
        EffectController(duration: 0.5),
      ),
    );
  }
}
