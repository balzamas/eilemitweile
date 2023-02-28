import 'package:EileMitWeile/components/screens/infoscreen.dart';
import 'package:EileMitWeile/components/sprites/heaven.dart';
import 'package:EileMitWeile/components/token.dart';
import 'package:EileMitWeile/enums.dart';
import 'package:flame/components.dart';

import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';

import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'components/field.dart';
import 'components/screens/maingame.dart';
import 'components/screens/newgame.dart';
import 'components/screens/victoryscreen.dart';
import 'components/sprites/dice_thrown.dart';
import 'components/sprites/move_buttons.dart';
import 'components/gamelogic.dart';
import 'components/player.dart';
import 'components/text_components/kills.dart';
import 'components/text_components/state.dart';

class EileMitWeileGame extends FlameGame with HasTappableComponents {
  late final RouterComponent router;

  @override
  Color backgroundColor() => Color.fromARGB(255, 245, 255, 157);

  bool is_hotseat = false;

  static const double fieldWidth = 200.0;
  static const double fieldHeight = 50.0;
  static const double tokenWidth = 50.0;
  static const double tokenHeight = 50.0;

  Vector2 fieldSizeVert =
      Vector2(EileMitWeileGame.fieldWidth, EileMitWeileGame.fieldHeight);
  Vector2 fieldSizeHoe =
      Vector2(EileMitWeileGame.fieldHeight, EileMitWeileGame.fieldWidth);
  double fieldRadius = 100.0;

  Vector2 tokenSize =
      Vector2(EileMitWeileGame.tokenWidth, EileMitWeileGame.tokenHeight);

  static const double info_col_size = 450;
  static const double button_size = 380;
  static const double console = info_col_size + button_size;

  double screenWidth = 2 * console + 1400;
  double screenHeight = 1600;

  late final KillInfo kill_text;
  late final State state_text_left;
  late final State state_text_right;

  late TextComponent round_num;
  late TextComponent kill_red;
  late TextComponent kill_blue;
  late TextComponent kill_green;
  late TextComponent kill_purple;

  bool audio_enabled = true;

  late AudioPool pool;

  List<Field> fields = [];
  List<Player> players = [];
  List<ButtonComponent> move_buttons = [];

  List<int> thrown_dices = [];
  List<DiceTComponent> dices_gfx = [];
  int current_dice = 0;
  bool can_throw_dice = true;

  final world = World();

  Player? current_player;
  Heaven heaven = Heaven();
  int round = 0;

  @override
  Future<void> onLoad() async {
    await FlameAudio.audioCache
        .loadAll(['kill/kill_1.wav', 'start/start_1.wav', 'start/start_2.wav']);

    await Flame.images.load('eilemitweile-sprites.png');
    add(
      router = RouterComponent(
        routes: {
          'game': Route(MainGame.new),
          'victory': Route(VictoryScreen.new, maintainState: false),
          'newgame': Route(NewGameScreen.new),
          'info': Route(InfoScreen.new)
        },
        initialRoute: 'newgame',
      ),
    );
  }

  void NextPlayer() {
    Future.delayed(const Duration(milliseconds: 500), () {
      for (DiceTComponent dice in dices_gfx) {
        dice.removeFromParent();
      }
      dices_gfx = [];
      can_throw_dice = true;
      thrown_dices = [];

      final index = players
          .indexWhere((element) => element.color == current_player!.color);
      if (index == 3) {
        round++;
        current_player = players[0];
      } else {
        current_player = players[index + 1];
      }

      this.move_buttons[0].setPlayerColor(current_player!.color);
      this.move_buttons[1].setPlayerColor(current_player!.color);
      this.move_buttons[2].setPlayerColor(current_player!.color);
      this.move_buttons[3].setPlayerColor(current_player!.color);
      if (is_hotseat == true) {
        this.move_buttons[4].setPlayerColor(current_player!.color);
        this.move_buttons[5].setPlayerColor(current_player!.color);
        this.move_buttons[6].setPlayerColor(current_player!.color);
        this.move_buttons[7].setPlayerColor(current_player!.color);
      }
      //Show Kills

      if (is_hotseat) {
        kill_text.text_content = "Turn " +
            round.toString() +
            " // Kills: Red " +
            players[0].bodycount.toString() +
            " // Blue " +
            players[1].bodycount.toString() +
            " // Green " +
            players[2].bodycount.toString() +
            " // Purple " +
            players[3].bodycount.toString();
      } else {
        round_num.text = round.toString();
        kill_red.text = players[0].bodycount.toString();
        kill_blue.text = players[1].bodycount.toString();
        kill_green.text = players[2].bodycount.toString();
        kill_purple.text = players[3].bodycount.toString();
      }

      if (current_player!.is_AI) {
        state_text_left.text_content = "";
        state_text_right.text_content = "";

        Future.delayed(const Duration(milliseconds: 500), () {
          ThrowDice(this);

          if (can_throw_dice) {
            ThrowDice(this);
          }

          if (can_throw_dice) {
            ThrowDice(this);
          }

          Future.delayed(const Duration(milliseconds: 500), () {
            int dices = thrown_dices.length;
            for (var i = 0; i < dices; i++) {
              if (CheckTokensToMove(this, thrown_dices[0])) {
                Move_KI(thrown_dices[0]);
              } else {
                thrown_dices.removeAt(0);
              }
            }
            for (Token token in current_player!.tokens) {
              if (token.last_round_moved == round) {
                token.MoveSprite();
              }
            }
            NextPlayer();
          });
        });
      } else {
        state_text_left.text_content = "🎲 Roll dice 🎲";
        state_text_right.text_content = "🎲 Roll dice 🎲";
      }
    });
  }

  void Move_KI(int dice_number) {
    //is there a token right behind me?
    for (Token token in current_player!.tokens) {
      if (token.can_move &&
          token.field!.number < 69 &&
          CheckIfTokenBehindMe(this, token, dice_number)) {
        Move(this, token, dice_number);
        return;
      }
    }
    if (dice_number == 5) {
      for (Token token in current_player!.tokens) {
        if (token.can_move && token.field!.number == 0) {
          Move(this, token, dice_number);
          return;
        }
      }
    }
    //Can token move on bench?
    for (Token token in current_player!.tokens) {
      if (token.can_move &&
          token.field!.number < 69 &&
          CheckIfTokenCanMoveOnBench(this, token, dice_number)) {
        Move(this, token, dice_number);
        return;
      }
    }

    //Can token kill?
    for (Token token in current_player!.tokens) {
      if (token.can_move &&
          token.field!.number < 69 &&
          CheckForPrey(this, token, dice_number)) {
        Move(this, token, dice_number);
        return;
      }
    }

    //Can token move on ladder?
    for (Token token in current_player!.tokens) {
      if (token.can_move &&
          token.field!.number <= token.player.heaven_start &&
          token.field!.number + dice_number > token.player.heaven_start) {
        Move(this, token, dice_number);
        return;
      }
    }

    //Move with tokens who are not on a bench/ladder and does not move into a danger zone
    for (Token token in current_player!.tokens) {
      if (token.can_move &&
          token.field!.current == FieldState.normal &&
          !CheckIfKillerBehindMe(this, token, dice_number)) {
        Move(this, token, dice_number);
        return;
      }
    }

    //Move with any token not on the ladder and does not move into a danger zone
    for (Token token in current_player!.tokens) {
      if (token.can_move &&
          token.field!.number < 69 &&
          !CheckIfKillerBehindMe(this, token, dice_number)) {
        Move(this, token, dice_number);
        return;
      }
    }

    //Move with tokens who are not on a bench/ladder
    for (Token token in current_player!.tokens) {
      if (token.can_move && token.field!.current == FieldState.normal) {
        Move(this, token, dice_number);
        return;
      }
    }

    //Move with tokens on ladder
    for (Token token in current_player!.tokens) {
      if (token.can_move && token.field!.current == FieldState.ladder) {
        Move(this, token, dice_number);
        return;
      }
    }

    for (Token token in current_player!.tokens) {
      if (token.can_move) {
        Move(this, token, dice_number);
        return;
      }
    }
  }

  void NewGame() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      round = 0;
      for (Player player in players) {
        player.bodycount = 0;
        for (Token token in player.tokens) {
          token.SendMeHome();
          token.bodycount = 0;
          token.last_round_moved = 0;
        }
      }

      current_player = players[3];
      NextPlayer();
    });
  }
}

Sprite emwSprite(double x, double y, double width, double height) {
  return Sprite(
    Flame.images.fromCache('eilemitweile-sprites.png'),
    srcPosition: Vector2(x, y),
    srcSize: Vector2(width, height),
  );
}
