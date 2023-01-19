import 'dart:math';
import 'dart:ui';

import 'package:EileMitWeile/components/tokens.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import '../eilemitweile_game.dart';
import 'package:flutter/widgets.dart';

import '../enums.dart';

class Dice extends PositionComponent with TapCallbacks, HasGameRef<EilemitweileGame> {

  @override
  bool get debugMode => false;

  static late final Sprite diceSprite = emwSprite(0, 651, 399, 399);
  
  @override
  void render(Canvas canvas) {
    diceSprite.render(canvas, position: Vector2(0, 0), anchor: Anchor.topLeft);
  }

  @override
  void onTapUp(TapUpEvent event) {
    int rand_num = Random().nextInt(6) + 1;
    if (rand_num == 6)
    {
      rand_num = 12;
    }
    gameRef.last_throw.last_throw = rand_num;

        //check which token can move
    bool has_moveable_token = false;
    for (Token token in gameRef.current_player!.tokens)
    {
      if (token.field!.current == FieldState.heaven)
      {
        token.can_move = false;
      }
      else if (token.field!.current == FieldState.home && rand_num != 5)
      {
        token.can_move = false;
      }
      else if (token.field!.number <= token.player.heaven_start && token.field!.number + rand_num > token.player.heaven_start)
        {
          int steps_in_heaven = rand_num - (token.player.heaven_start - token.field!.number);
          if (steps_in_heaven > 9)
          {
            token.can_move = false;
          }
        }
      else if (token.field!.number + rand_num > 76)
      {
          token.can_move = false;
      }
      else if (check_for_blocked_fields(token, rand_num))
      {
          token.can_move = false;
      }
      else {
        token.can_move = true;
        has_moveable_token = true;
      }
    }
    if (!has_moveable_token)
    {
      gameRef.NextPlayer();
    }
  }
  
  bool check_for_blocked_fields(Token token, int moves) {
      bool is_blocked = false;
        int start_field = token.field!.number;
        int end_field = 0;

        if (start_field <= token.player.heaven_start && start_field + game.last_throw.last_throw > token.player.heaven_start)
        {
          is_blocked = field_blocked(start_field, token.player.heaven_start, token);

        }
        else if (start_field < 69 && (start_field + game.last_throw.last_throw > 68))
        {
          end_field = start_field + game.last_throw.last_throw - 68;

          bool test1 = false;
          bool test2 =false;

          test1 = field_blocked(start_field, 68, token);
          test2 = field_blocked(0, end_field, token);

          if (test1 || test2 )
          {
            is_blocked = true;
          }
        }
        else
          {
            is_blocked = field_blocked(start_field, (start_field + game.last_throw.last_throw), token);
          }
    return is_blocked;
  }

  bool field_blocked(start_field, end_field, moving_token)
  {
    for(var i = start_field; i < end_field; i++)
    {
      if (gameRef.fields[i].current == FieldState.bench && gameRef.fields[i].tokens.length > 1)
      {
        var playerCounter = 0;
        int playerFirstArrival = 999999999999;
        var otherPlayersCounter = {gameRef.players[0]:0, gameRef.players[1]:0, gameRef.players[2]:0, gameRef.players[3]:0};
          
        for (Token token in gameRef.fields[i].tokens)
        {
          if (token.player != moving_token.player)
          {
            otherPlayersCounter[token.player] = (otherPlayersCounter[token.player]! + 1);
          }
          else
          {
              playerCounter++;
              if (playerFirstArrival == 999999999999) {
                playerFirstArrival = token.last_round_moved;
              } else if (token.last_round_moved < playerFirstArrival) {
                playerFirstArrival = token.last_round_moved;
              }
          }
        }

        if (playerCounter < otherPlayersCounter[gameRef.players[0]]! && otherPlayersCounter[gameRef.players[0]]! > 1)
        {
            return true;
        }
        if (playerCounter < otherPlayersCounter[gameRef.players[1]]! && otherPlayersCounter[gameRef.players[1]]! > 1)
        {
            return true;
        }
        if (playerCounter < otherPlayersCounter[gameRef.players[2]]! && otherPlayersCounter[gameRef.players[2]]! > 1)
        {
            return true;
        }
        if (playerCounter < otherPlayersCounter[gameRef.players[3]]! && otherPlayersCounter[gameRef.players[3]]! > 1)
        {
            return true;
        }
      }
    }
    return false;
  }
}