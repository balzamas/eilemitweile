import 'dart:ui';

import 'package:EileMitWeile/components/movement.dart';
import 'package:EileMitWeile/components/player.dart';
import 'package:EileMitWeile/enums.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import '../eilemitweile_game.dart';
import 'field.dart';

class Token extends PositionComponent with TapCallbacks, HasPaint, HasGameRef<EilemitweileGame> {
  bool can_move = false;
  int last_round_moved = 0;
  int cur_tile = 0;
  int token_number = 0;
  late Player player;
  Field? field;
  Token(Player player)
  {
    this.player = player;
  }

  @override
  bool get debugMode => false;

  static late final Sprite tokenSprite_red = emwSprite(201, 0, 50, 50);
  static late final Sprite tokenSprite_blue = emwSprite(201, 50, 50, 50);
  static late final Sprite tokenSprite_green = emwSprite(250, 0, 50, 50);
  static late final Sprite tokenSprite_yellow = emwSprite(250, 50, 50, 50);
  
  @override
  void render(Canvas canvas) {
    if (player.color == 1)
      tokenSprite_red.render(canvas, position: Vector2(0, 0), anchor: Anchor.topLeft);
    else if (player.color == 2)
      tokenSprite_blue.render(canvas, position: Vector2(0, 0), anchor: Anchor.topLeft);
    else if (player.color == 3)
      tokenSprite_green.render(canvas, position: Vector2(0, 0), anchor: Anchor.topLeft);
    else
      tokenSprite_yellow.render(canvas, position: Vector2(0, 0), anchor: Anchor.topLeft);
  }

  @override
  void onTapUp(TapUpEvent event) {

    if (gameRef.current_player == this.player && this.can_move)
    {
          Move(gameRef, this);
    }

    
  }

  void sendHome(start_field, end_field)
  {
    for(var i = start_field + 1; i < end_field; i++)
    {
      if (gameRef.fields[i].tokens.length > 0)
      {
        gameRef.fields[i].sendHomeTokens(this.player, gameRef.fields[0]);
      }
    }
  }
}