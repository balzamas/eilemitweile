import 'dart:math';

import 'package:EileMitWeile/components/player.dart';
import 'package:EileMitWeile/components/sprites/dice_thrown.dart';
import 'package:EileMitWeile/components/sprites/threesix.dart';
import 'package:EileMitWeile/components/token.dart';
import 'package:EileMitWeile/eilemitweile_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../enums.dart';
import 'field.dart';

const tau = 2 * pi;

void Move(EileMitWeileGame game, Token token, int moves) {
  if (token.field!.number == 0) {
    token.field!.removeToken(token);
    SendHome(token.player.start_field, token.player.start_field + moves, game,
        token);
    token.field = game.fields[token.player.start_field + moves];
    token.field!.tokens.add(token);

    token.last_round_moved = game.round;
  } else {
    token.field!.removeToken(token);
    token.field!.rearrangeTokens();

    int start_field = token.field!.number;
    int end_field = 0;

    if (start_field <= token.player.heaven_start &&
        start_field + moves > token.player.heaven_start) {
      int steps_in_heaven = moves - (token.player.heaven_start - start_field);
      SendHome(start_field, token.player.heaven_start, game, token);
      end_field = 68 + steps_in_heaven;
    } else if (start_field < 69 && (start_field + moves > 68)) {
      end_field = start_field + moves - 68;

      SendHome(start_field, 68, game, token);
      SendHome(0, end_field, game, token);
    } else {
      end_field = start_field + moves;
      SendHome(start_field, end_field, game, token);
    }
    token.field = game.fields[end_field];
    token.field!.tokens.add(token);

    token.last_round_moved = game.round;
  }

  game.thrown_dices.removeAt(0);
  game.dices_gfx[0].removeFromParent();
  game.dices_gfx.removeAt(0);

  PaintDices(game);

  if (CheckVictory(token.player)) {
    game.router.pushNamed('victory');
    game.NewGame();
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

void ShowTripleSixMessage(EileMitWeileGame game) {
  ThreeSix threesix = ThreeSix();
  threesix.position = Vector2(
      EileMitWeileGame.console +
          8 * EileMitWeileGame.fieldHeight +
          1.5 * EileMitWeileGame.fieldWidth,
      game.screenHeight / 2);
  threesix.add(RemoveEffect(delay: 1.0));
  game.world.add(threesix);
}

void SendHome(start_field, end_field, EileMitWeileGame game, Token token) {
  for (var i = start_field + 1; i < end_field; i++) {
    if (game.fields[i].tokens.length > 0) {
      int sent_home = game.fields[i].sendHomeTokens(token.player);
      token.player.bodycount = token.player.bodycount + sent_home;
      token.bodycount = token.bodycount + sent_home;
    }
  }
}

void PaintDices(EileMitWeileGame game) {
  if (game.is_hotseat == true) {
    if (game.thrown_dices.length == 1) {
      game.dices_gfx[0].position = Vector2(
          EileMitWeileGame.console +
              8 * EileMitWeileGame.fieldHeight +
              EileMitWeileGame.fieldWidth +
              5,
          9 * EileMitWeileGame.fieldHeight +
              2 * EileMitWeileGame.fieldWidth +
              EileMitWeileGame.fieldHeight +
              5);
      game.dices_gfx[0].changeParent(game.world);
    } else if (game.thrown_dices.length == 2) {
      game.dices_gfx[0].position = Vector2(
          EileMitWeileGame.console +
              8 * EileMitWeileGame.fieldHeight +
              0.5 * EileMitWeileGame.fieldWidth +
              5,
          9 * EileMitWeileGame.fieldHeight +
              2 * EileMitWeileGame.fieldWidth +
              EileMitWeileGame.fieldHeight +
              5);

      game.dices_gfx[1].position = Vector2(
          EileMitWeileGame.console +
              8 * EileMitWeileGame.fieldHeight +
              1.5 * EileMitWeileGame.fieldWidth +
              5,
          9 * EileMitWeileGame.fieldHeight +
              2 * EileMitWeileGame.fieldWidth +
              EileMitWeileGame.fieldHeight +
              5);
      game.dices_gfx[1].changeParent(game.world);
    } else if (game.thrown_dices.length == 3) {
      game.dices_gfx[0].position = Vector2(
          EileMitWeileGame.console + 8 * EileMitWeileGame.fieldHeight + 5,
          9 * EileMitWeileGame.fieldHeight +
              2 * EileMitWeileGame.fieldWidth +
              EileMitWeileGame.fieldHeight +
              5);
      game.dices_gfx[1].position = Vector2(
          EileMitWeileGame.console +
              8 * EileMitWeileGame.fieldHeight +
              EileMitWeileGame.fieldWidth +
              5,
          9 * EileMitWeileGame.fieldHeight +
              2 * EileMitWeileGame.fieldWidth +
              EileMitWeileGame.fieldHeight +
              5);

      game.dices_gfx[2].position = Vector2(
          EileMitWeileGame.console +
              8 * EileMitWeileGame.fieldHeight +
              2 * EileMitWeileGame.fieldWidth +
              5,
          9 * EileMitWeileGame.fieldHeight +
              2 * EileMitWeileGame.fieldWidth +
              EileMitWeileGame.fieldHeight +
              5);
      game.dices_gfx[2].changeParent(game.world);
    }
  } else {
    if (game.thrown_dices.length > 0) {
      game.dices_gfx[0].size = Vector2(300, 300);
      game.dices_gfx[0].position = Vector2(
          EileMitWeileGame.info_col_size, 2 * EileMitWeileGame.fieldHeight);
      game.dices_gfx[0].changeParent(game.world);
    }
    if (game.thrown_dices.length > 1) {
      game.dices_gfx[1].size = Vector2(300, 300);

      game.dices_gfx[1].position = Vector2(EileMitWeileGame.info_col_size,
          3 * EileMitWeileGame.fieldHeight + 300);
      game.dices_gfx[1].changeParent(game.world);
    }
    if (game.thrown_dices.length > 2) {
      game.dices_gfx[2].size = Vector2(300, 300);

      game.dices_gfx[2].position = Vector2(EileMitWeileGame.info_col_size,
          4 * EileMitWeileGame.fieldHeight + 600);
      game.dices_gfx[2].changeParent(game.world);
    }
  }
}

bool ThrowDice(EileMitWeileGame game) {
  bool start_next_player = false;

  int rand_num = Random().nextInt(6) + 1;

  if (rand_num == 6) {
    rand_num = 12;
  }

  game.thrown_dices.add(rand_num);

  game.dices_gfx.add(DiceTComponent(
    position: Vector2(0, 0),
    dice_number: rand_num,
  ));
  PaintDices(game);

  if (rand_num == 12 && game.thrown_dices.length == 3) {
    //Send all home!
    for (Token token in game.current_player!.tokens) {
      if (token.field!.number != 0 && token.field!.number < 69) {
        token.SendMeHome();
      }
      ShowTripleSixMessage(game);

      game.thrown_dices = [];
      start_next_player = true;
    }
  }
  if (rand_num != 12) {
    game.can_throw_dice = false;

    if (CheckTokensToMove(
            game, game.thrown_dices[game.thrown_dices.length - 1]) ==
        false) {
      start_next_player = true;
    } else {
      if (!game.current_player!.is_AI) {
        if (game.is_hotseat == true) {
          game.state_text_left.text_content = "🔼 Move 🔼";
        } else {
          game.state_text_left.text_content = "Move";
        }
        game.state_text_right.text_content = "🔼 Move 🔼";
      }
    }
  }

  return start_next_player;
}

bool CheckTokensToMove(EileMitWeileGame game, int dice_number) {
  //check which token can move
  bool has_moveable_token = false;
  for (Token token in game.current_player!.tokens) {
    if (CheckIfTokenCanMove(game, token, dice_number)) {
      has_moveable_token = true;
    }
  }
  return has_moveable_token;
}

bool CheckIfTokenBehindMe(
    EileMitWeileGame game, Token token, int thrown_number) {
  if (token.field!.current == FieldState.normal) {
    if (token.field!.number == 1) {
      bool is_in_danger = false;
      if (CheckFieldForEnemyToken(game.fields[68], token)) {
        is_in_danger = true;
      }
      if (CheckFieldForEnemyToken(game.fields[67], token)) {
        is_in_danger = true;
      }
      return is_in_danger;
    }
    if (token.field!.number == 2) {
      bool is_in_danger = false;
      if (CheckFieldForEnemyToken(game.fields[68], token)) {
        is_in_danger = true;
      }
      if (CheckFieldForEnemyToken(game.fields[1], token)) {
        is_in_danger = true;
      }
      return is_in_danger;
    }

    bool is_in_danger = false;
    if (CheckFieldForEnemyToken(game.fields[token.field!.number - 1], token)) {
      is_in_danger = true;
    }
    if (CheckFieldForEnemyToken(game.fields[token.field!.number - 1], token)) {
      is_in_danger = true;
    }
    return is_in_danger;
  }
  return false;
}

bool CheckFieldForEnemyToken(Field field, Token token) {
  int enemy_tokens = 0;
  for (Token token_on_field in field.tokens) {
    if (token_on_field.player != token.player) {
      enemy_tokens++;
    }
  }
  if (enemy_tokens > 0) {
    return true;
  }
  return false;
}

bool CheckIfTokenCanMoveOnBench(
    EileMitWeileGame game, Token token, int thrown_number) {
  int end_field = 0;
  if (token.field!.number <= token.player.heaven_start &&
      token.field!.number + thrown_number > token.player.heaven_start) {
    int steps_in_heaven =
        thrown_number - (token.player.heaven_start - token.field!.number);
    SendHome(token.field!.number, token.player.heaven_start, game, token);
    end_field = 68 + steps_in_heaven;
  } else if (token.field!.number < 69 &&
      (token.field!.number + thrown_number > 68)) {
    end_field = token.field!.number + thrown_number - 68;
  } else {
    end_field = token.field!.number + thrown_number;
  }

  if (token.field!.current != FieldState.ladder &&
      !(token.field!.number <= token.player.heaven_start &&
          token.field!.number + thrown_number > token.player.heaven_start) &&
      game.fields[end_field].current == FieldState.bench) {
    return true;
  }
  return false;
}

bool CheckIfTokenCanMove(EileMitWeileGame game, Token token, thrown_number) {
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
    if (steps_in_heaven > 8) {
      token.can_move = false;
      return false;
    }
  }
  if (token.field!.current == FieldState.bench &&
      CheckBenchBlock(game, token)) {
    token.can_move = false;
    return false;
  }
  if (token.field!.current == FieldState.ladder &&
      token.field!.number + thrown_number > 76) {
    token.can_move = false;
    return false;
  }
  if (token.field!.current != FieldState.ladder &&
      CheckForBlockedFields(game, token, thrown_number)) {
    token.can_move = false;
    return false;
  }

  return true;
}

bool CheckBenchBlock(EileMitWeileGame game, Token token) {
  final index = token.field!.tokens.indexWhere((element) => element == token);
  int playerCounter = 0;
  var otherPlayersCounter = {
    game.players[0]: 0,
    game.players[1]: 0,
    game.players[2]: 0,
    game.players[3]: 0
  };

  for (var i = 0; i < index; i++) {
    if (token.field!.tokens[i].player != token.player) {
      otherPlayersCounter[token.field!.tokens[i].player] =
          (otherPlayersCounter[token.field!.tokens[i].player]! + 1);
    } else {
      playerCounter++;
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

  return false;
}

bool CheckForPrey(EileMitWeileGame game, Token token, int moves) {
  int start_field = token.field!.number;
  int end_field = 0;

  if (start_field <= token.player.heaven_start &&
      start_field + moves > token.player.heaven_start) {
    return FieldPrey(game, start_field, token.player.heaven_start, token);
  } else if (start_field < 69 && (start_field + moves > 68)) {
    end_field = start_field + moves - 68;

    return FieldPrey(game, start_field, 68, token);
  } else {
    return FieldPrey(game, start_field, (start_field + moves), token);
  }
}

bool FieldPrey(EileMitWeileGame game, start_field, end_field, moving_token) {
  bool has_prey = false;
  for (var i = start_field + 1; i < end_field; i++) {
    if (game.fields[i].current == FieldState.normal &&
        game.fields[i].tokens.length > 0) {
      for (Token token in game.fields[i].tokens) {
        if (token.player != game.current_player) {
          has_prey = true;
        }
      }
    }
  }
  return has_prey;
}

bool CheckForBlockedFields(EileMitWeileGame game, Token token, int moves) {
  bool is_blocked = false;
  int start_field = token.field!.number;
  int end_field = token.field!.number + moves;

  if (start_field <= token.player.heaven_start &&
      end_field > token.player.heaven_start) {
    is_blocked = FieldBlocked(
        game, start_field + 1, token.player.heaven_start + 1, token);
  } else if (start_field < 69 && (end_field > 68)) {
    end_field = end_field - 68;

    bool test1 = false;
    bool test2 = false;

    test1 = FieldBlocked(game, start_field + 1, 69, token);
    test2 = FieldBlocked(game, 0, end_field, token);

    if (test1 || test2) {
      is_blocked = true;
    }
  } else {
    is_blocked = FieldBlocked(game, start_field + 1, end_field, token);
  }
  return is_blocked;
}

bool FieldBlocked(
    EileMitWeileGame game, start_field, end_field, Token moving_token) {
  for (var i = start_field; i < end_field; i++) {
    if (game.fields[i].current == FieldState.bench &&
        game.fields[i].tokens.length > 1) {
      var playerCounter = 0;
      var otherPlayersCounter = {
        game.players[0]: 0,
        game.players[1]: 0,
        game.players[2]: 0,
        game.players[3]: 0
      };
      Player? first_double;
      Player? first_triple;

      for (Token token in game.fields[i].tokens) {
        if (token.player != moving_token.player) {
          otherPlayersCounter[token.player] =
              (otherPlayersCounter[token.player]! + 1);
          if (otherPlayersCounter[token.player]! == 2 && first_double == null) {
            first_double = token.player;
          }
          if (otherPlayersCounter[token.player]! == 3 && first_triple == null) {
            first_triple = token.player;
          }
        } else {
          playerCounter++;
          if (playerCounter == 2 && first_double == null) {
            first_double = token.player;
          }
          if (playerCounter == 3 && first_triple == null) {
            first_triple = token.player;
          }
        }
      }

      if (playerCounter <= otherPlayersCounter[game.players[0]]! &&
          otherPlayersCounter[game.players[0]]! > 1 &&
          first_double != moving_token.player &&
          first_triple != moving_token.player) {
        return true;
      }
      if (playerCounter <= otherPlayersCounter[game.players[1]]! &&
          otherPlayersCounter[game.players[1]]! > 1 &&
          first_double != moving_token.player &&
          first_triple != moving_token.player) {
        return true;
      }
      if (playerCounter <= otherPlayersCounter[game.players[2]]! &&
          otherPlayersCounter[game.players[2]]! > 1 &&
          first_double != moving_token.player &&
          first_triple != moving_token.player) {
        return true;
      }
      if (playerCounter <= otherPlayersCounter[game.players[3]]! &&
          otherPlayersCounter[game.players[3]]! > 1 &&
          first_double != moving_token.player &&
          first_triple != moving_token.player) {
        return true;
      }
    }
  }
  return false;
}
