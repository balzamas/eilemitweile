import 'dart:math';
import 'dart:ui';

import 'package:EileMitWeile/components/paeng.dart';
import 'package:EileMitWeile/components/player.dart';
import 'package:EileMitWeile/components/tokens.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import '../eilemitweile_game.dart';
import '../enums.dart';

const tau = 2 * pi;

class Field extends SpriteGroupComponent<FieldState>
    with HasGameRef<EilemitweileGame> {
  bool isRotated = false;
  Player? player;
  int number = 1;
  List<Token> tokens = [];
  late final FieldState fieldst;

  Field({required this.fieldst});

  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {
    final Sprite spriteNormal = emwSprite(0, 0, 200, 50);
    final Sprite spriteBench = emwSprite(0, 50, 200, 50);
    final Sprite spriteLadder1 = emwSprite(202, 0, 200, 50);
    final Sprite spriteLadder2 = emwSprite(202, 50, 200, 50);
    final Sprite spriteLadder3 = emwSprite(403, 0, 200, 50);
    final Sprite spriteLadder4 = emwSprite(403, 50, 200, 50);

    sprites = {
      FieldState.normal: spriteNormal,
      FieldState.bench: spriteBench,
      FieldState.ladder_1: spriteLadder1,
      FieldState.ladder_2: spriteLadder2,
      FieldState.ladder_3: spriteLadder3,
      FieldState.ladder_4: spriteLadder4,
      FieldState.home: spriteNormal,
      FieldState.heaven: spriteNormal,
      FieldState.ladder: spriteNormal
    };

    width = EilemitweileGame.fieldWidth;
    height = EilemitweileGame.fieldHeight;

    anchor = Anchor.topLeft;

    current = fieldst;
  }

  @override
  void update(double dt) {}

  Vector2 addToken(Token token) {
    token.field = this;
    Vector2 token_pos = Vector2(0, 0);
    if (this.current == FieldState.heaven) {
      token_pos = Vector2(
          (gameRef.heaven.x +
              (tokens.length * (EilemitweileGame.tokenHeight)) +
              80),
          gameRef.heaven.y + 80);
    } else if (this.current == FieldState.home) {
      switch (token.token_number) {
        case 0:
          {
            token_pos = Vector2(token.player.home_x + 75,
                token.player.home_y + 75 + EilemitweileGame.tokenHeight);
          }
          break;

        case 1:
          {
            token_pos = Vector2(token.player.home_x + 275,
                token.player.home_y + 75 + EilemitweileGame.tokenHeight);
          }
          break;

        case 2:
          {
            token_pos = Vector2(token.player.home_x + 75,
                token.player.home_y + 275 + EilemitweileGame.tokenHeight);
          }
          break;

        case 3:
          {
            token_pos = Vector2(token.player.home_x + 275,
                token.player.home_y + 275 + EilemitweileGame.tokenHeight);
          }
          break;
      }
    } else if (this.current == FieldState.ladder) {
      int ladder_pos = this.number - 69;

      if (this.isRotated) {
        token_pos = Vector2(
            (token.player.ladder_fields[ladder_pos].x -
                EilemitweileGame.fieldHeight),
            token.player.ladder_fields[ladder_pos].y);
      } else {
        token_pos = Vector2((token.player.ladder_fields[ladder_pos].x),
            token.player.ladder_fields[ladder_pos].y);
      }
    } else if (this.isRotated) {
      token_pos = Vector2((this.position.x - EilemitweileGame.fieldHeight),
          this.position.y + (tokens.length * (EilemitweileGame.tokenHeight)));
    } else {
      token_pos = Vector2(
          (this.position.x + (tokens.length * (EilemitweileGame.tokenHeight))),
          this.position.y);
    }
    tokens.add(token);
    return token_pos;
  }

  void removeToken(Token token) {
    tokens.remove(token);
  }

  void rearrangeTokens() {
    int token_num = 0;
    for (Token token in tokens) {
      if (this.current == FieldState.normal ||
          this.current == FieldState.bench) {
        if (this.isRotated) {
          token.position = Vector2(
              (this.position.x - EilemitweileGame.fieldHeight),
              this.position.y + (token_num * (EilemitweileGame.tokenHeight)));
        } else {
          token.position = Vector2(
              (this.position.x + (token_num * (EilemitweileGame.tokenHeight))),
              this.position.y);
        }
      }
      token_num++;
    }
  }

  int sendHomeTokens(Player player, Field homefield) {
    int sentHome = 0;
    if (this.current != FieldState.bench && this.current != FieldState.ladder) {
      List<Token> tokens_to_send_home = [];
      for (Token token in tokens) {
        if (token.player != player) {
          tokens_to_send_home.add(token);
        }
      }

      for (Token token_to_send_home in tokens_to_send_home) {
        sentHome++;

        Paeng paeng = Paeng();
        paeng.position = Vector2(
            token_to_send_home.position.x + 25, token_to_send_home.y + 25);
        //paeng.angle = pi / 3;
        gameRef.world.add(paeng);
        paeng.add(RemoveEffect(delay: 1.0));

        tokens.remove(token_to_send_home);
        token_to_send_home.add(
          MoveEffect.to(
            homefield.addToken(token_to_send_home),
            EffectController(duration: 0.5),
          ),
        );
      }
    }
    return sentHome;
  }
}
