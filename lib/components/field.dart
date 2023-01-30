import 'dart:math';

import 'package:EileMitWeile/components/player.dart';
import 'package:EileMitWeile/components/token.dart';
import 'package:flame/components.dart';
import '../eilemitweile_game.dart';
import '../enums.dart';

const tau = 2 * pi;

class Field extends SpriteGroupComponent<FieldState>
    with HasGameRef<EileMitWeileGame> {
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

    width = EileMitWeileGame.fieldWidth;
    height = EileMitWeileGame.fieldHeight;

    anchor = Anchor.topLeft;

    current = fieldst;
  }

  @override
  void update(double dt) {}

  Vector2 getTokenPosition(Token token) {
    Vector2 token_pos = Vector2(0, 0);
    if (this.current == FieldState.heaven) {
      token_pos = Vector2(
          (gameRef.heaven.x +
              ((tokens.length - 1) * (EileMitWeileGame.tokenHeight)) +
              80),
          gameRef.heaven.y + 80);
    } else if (this.current == FieldState.home) {
      switch (token.token_number) {
        case 0:
          {
            token_pos = Vector2(token.player.home_x + 75,
                token.player.home_y + 75 + EileMitWeileGame.tokenHeight);
          }
          break;

        case 1:
          {
            token_pos = Vector2(token.player.home_x + 275,
                token.player.home_y + 75 + EileMitWeileGame.tokenHeight);
          }
          break;

        case 2:
          {
            token_pos = Vector2(token.player.home_x + 75,
                token.player.home_y + 275 + EileMitWeileGame.tokenHeight);
          }
          break;

        case 3:
          {
            token_pos = Vector2(token.player.home_x + 275,
                token.player.home_y + 275 + EileMitWeileGame.tokenHeight);
          }
          break;
      }
    } else if (this.current == FieldState.ladder) {
      int ladder_pos = this.number - 69;

      int token_count = 0;
      for (Token token in this.tokens) {
        if (token.player == gameRef.current_player) {
          token_count++;
        }
      }

      if (gameRef.current_player == gameRef.players[1] ||
          gameRef.current_player == gameRef.players[3]) {
        token_pos = Vector2(
            (token.player.ladder_fields[ladder_pos].x -
                (1 * EileMitWeileGame.fieldHeight)),
            token.player.ladder_fields[ladder_pos].y +
                (token_count - 1) * EileMitWeileGame.fieldHeight);
      } else {
        token_pos = Vector2(
            (token.player.ladder_fields[ladder_pos].x +
                (token_count - 1) * EileMitWeileGame.fieldHeight),
            token.player.ladder_fields[ladder_pos].y);
      }
    } else if (this.isRotated) {
      token_pos = Vector2(
          (this.position.x - EileMitWeileGame.fieldHeight),
          this.position.y +
              ((tokens.length - 1) * (EileMitWeileGame.tokenHeight)));
    } else {
      token_pos = Vector2(
          (this.position.x +
              ((tokens.length - 1) * (EileMitWeileGame.tokenHeight))),
          this.position.y);
    }
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
        if (this.tokens.length > 4) {
          if (this.isRotated) {
            token.position = Vector2(
                (this.position.x - EileMitWeileGame.fieldHeight),
                this.position.y +
                    (token_num * (EileMitWeileGame.tokenHeight / 2)));
          } else {
            token.position = Vector2(
                (this.position.x +
                    (token_num * (EileMitWeileGame.tokenHeight / 2))),
                this.position.y);
          }
        } else {
          if (this.isRotated) {
            token.position = Vector2(
                (this.position.x - EileMitWeileGame.fieldHeight),
                this.position.y + (token_num * (EileMitWeileGame.tokenHeight)));
          } else {
            token.position = Vector2(
                (this.position.x +
                    (token_num * (EileMitWeileGame.tokenHeight))),
                this.position.y);
          }
        }
      }
      token_num++;
    }
  }

  int sendHomeTokens(Player player) {
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

        token_to_send_home.SendMeHome();
      }
    }
    return sentHome;
  }
}
