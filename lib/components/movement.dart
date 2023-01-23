import 'dart:math';

import 'package:EileMitWeile/components/player.dart';
import 'package:EileMitWeile/components/tokens.dart';
import 'package:EileMitWeile/components/victory.dart';
import 'package:EileMitWeile/eilemitweile_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import '../enums.dart';

const tau = 2 * pi;

void Move(EilemitweileGame game, Token token) {
  if (token.field!.number == 0) {
    token.field!.removeToken(token);
    sendHome(token.player.start_field + 1,
        token.player.start_field + game.last_throw.last_throw - 1, game, token);
    token.field =
        game.fields[token.player.start_field + game.last_throw.last_throw];
    token.add(
      MoveEffect.to(
        token.field!.addToken(token),
        EffectController(duration: 0.5),
      ),
    );
    token.last_round_moved = game.round;
    //token.position = token.field!.addToken(token);
    game.NextPlayer();
  } else {
    token.field!.removeToken(token);
    token.field!.rearrangeTokens();

    int start_field = token.field!.number;
    int end_field = 0;

    if (start_field <= token.player.heaven_start &&
        start_field + game.last_throw.last_throw > token.player.heaven_start) {
      int steps_in_heaven = game.last_throw.last_throw -
          (token.player.heaven_start - start_field);
      sendHome(start_field, token.player.heaven_start, game, token);
      end_field = 68 + steps_in_heaven;
    } else if (start_field < 69 &&
        (start_field + game.last_throw.last_throw > 68)) {
      end_field = start_field + game.last_throw.last_throw - 68;

      sendHome(start_field, 68, game, token);
      sendHome(0, end_field, game, token);
    } else {
      end_field = start_field + game.last_throw.last_throw;
      sendHome(start_field, end_field, game, token);
    }
    token.field = game.fields[end_field];

    token.add(
      MoveEffect.to(
        token.field!.addToken(token),
        EffectController(duration: 0.5),
      ),
    );
    token.last_round_moved = game.round;
    for (Token token in game.current_player!.tokens) {
      token.can_move = false;
    }
    if (CheckVictory(token.player)) {
      ShowVictoryMessage(token.player, game);
    } else {
      game.NextPlayer();
    }
  }
}

bool CheckVictory(Player player) {
  int token_in_heaven = 0;

  for (Token token in player.tokens) {
    if (token.field!.number == 76) {
      token_in_heaven++;
    }
  }

  if (token_in_heaven == 4) {
    return true;
  }
  return false;
}

void ShowVictoryMessage(Player player, EilemitweileGame game) {
  Victory victory = Victory();
  victory.position = Vector2(
      EilemitweileGame.console +
          8 * EilemitweileGame.fieldHeight +
          1.5 * EilemitweileGame.fieldWidth,
      EilemitweileGame.screenHeight / 2 - 100);
  victory.add(RemoveEffect(delay: 2.0));
  game.world.add(victory);

  final style = TextStyle(color: BasicPalette.black.color, fontSize: 120);

  TextPaint textPaint = TextPaint(style: style);
  TextComponent winner =
      TextComponent(text: player.name, textRenderer: textPaint);

  winner.position = Vector2(EilemitweileGame.screenWidth / 2,
      EilemitweileGame.screenHeight / 2 + 100);
  winner.add(RemoveEffect(delay: 2.0));

  game.world.add(winner);
}

void sendHome(start_field, end_field, EilemitweileGame game, Token token) {
  for (var i = start_field + 1; i < end_field; i++) {
    if (game.fields[i].tokens.length > 0) {
      token.player.bodycount = token.player.bodycount +
          game.fields[i].sendHomeTokens(token.player, game.fields[0]);
      token.bodycount = token.bodycount +
          game.fields[i].sendHomeTokens(token.player, game.fields[0]);
    }
  }
}

void ThrowDice(EilemitweileGame game) {
  int rand_num = Random().nextInt(6) + 1;
  if (rand_num == 6) {
    rand_num = 12;
  }
  game.last_throw.last_throw = rand_num;

  //check which token can move
  game.current_player!.has_moveable_token = false;
  for (Token token in game.current_player!.tokens) {
    if (check_if_token_can_move(game, token, rand_num)) {
      game.current_player!.has_moveable_token = true;
    }
  }
  if (!game.current_player!.has_moveable_token) {
    game.NextPlayer();
  }
}

bool check_if_token_can_move(
    EilemitweileGame game, Token token, thrown_number) {
  token.can_move = true;

  if (token.field!.current == FieldState.heaven) {
    token.can_move = false;
    return false;
  }
  if (token.field!.current == FieldState.home && thrown_number != 5) {
    token.can_move = false;
    return false;
  }
  if (token.field!.number <= token.player.heaven_start &&
      token.field!.number + thrown_number > token.player.heaven_start) {
    int steps_in_heaven =
        thrown_number - (token.player.heaven_start - token.field!.number);
    if (steps_in_heaven > 9) {
      token.can_move = false;
      return false;
    }
  }
  if (token.field!.number + thrown_number > 76) {
    token.can_move = false;
    return false;
  }
  if (check_for_blocked_fields(game, token, thrown_number)) {
    token.can_move = false;
    return false;
  }

  return true;
}

bool check_for_blocked_fields(EilemitweileGame game, Token token, int moves) {
  bool is_blocked = false;
  int start_field = token.field!.number;
  int end_field = 0;

  if (start_field <= token.player.heaven_start &&
      start_field + game.last_throw.last_throw > token.player.heaven_start) {
    is_blocked =
        field_blocked(game, start_field, token.player.heaven_start, token);
  } else if (start_field < 69 &&
      (start_field + game.last_throw.last_throw > 68)) {
    end_field = start_field + game.last_throw.last_throw - 68;

    bool test1 = false;
    bool test2 = false;

    test1 = field_blocked(game, start_field, 68, token);
    test2 = field_blocked(game, 0, end_field, token);

    if (test1 || test2) {
      is_blocked = true;
    }
  } else {
    is_blocked = field_blocked(
        game, start_field, (start_field + game.last_throw.last_throw), token);
  }
  return is_blocked;
}

bool field_blocked(
    EilemitweileGame game, start_field, end_field, moving_token) {
  for (var i = start_field; i < end_field; i++) {
    if (game.fields[i].current == FieldState.bench &&
        game.fields[i].tokens.length > 1) {
      var playerCounter = 0;
      int playerFirstArrival = 999999999999;
      var otherPlayersCounter = {
        game.players[0]: 0,
        game.players[1]: 0,
        game.players[2]: 0,
        game.players[3]: 0
      };

      for (Token token in game.fields[i].tokens) {
        if (token.player != moving_token.player) {
          otherPlayersCounter[token.player] =
              (otherPlayersCounter[token.player]! + 1);
        } else {
          playerCounter++;
          if (playerFirstArrival == 999999999999) {
            playerFirstArrival = token.last_round_moved;
          } else if (token.last_round_moved < playerFirstArrival) {
            playerFirstArrival = token.last_round_moved;
          }
        }
      }

      if (playerCounter < otherPlayersCounter[game.players[0]]! &&
          otherPlayersCounter[game.players[0]]! > 1) {
        return true;
      }
      if (playerCounter < otherPlayersCounter[game.players[1]]! &&
          otherPlayersCounter[game.players[1]]! > 1) {
        return true;
      }
      if (playerCounter < otherPlayersCounter[game.players[2]]! &&
          otherPlayersCounter[game.players[2]]! > 1) {
        return true;
      }
      if (playerCounter < otherPlayersCounter[game.players[3]]! &&
          otherPlayersCounter[game.players[3]]! > 1) {
        return true;
      }
    }
  }
  return false;
}
