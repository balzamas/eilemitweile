import 'package:EileMitWeile/components/screens/infoscreen.dart';
import 'package:EileMitWeile/components/sprites/dice.dart';
import 'package:EileMitWeile/components/sprites/heaven.dart';
import 'package:EileMitWeile/components/text_components/infotext.dart';
import 'package:EileMitWeile/components/sprites/move_button.dart';
import 'package:EileMitWeile/components/token.dart';
import 'package:EileMitWeile/enums.dart';
import 'package:flame/components.dart';

import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';

import 'package:flame/game.dart';
import 'package:flame/palette.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'components/field.dart';
import 'components/screens/maingame.dart';
import 'components/screens/newgame.dart';
import 'components/screens/victoryscreen.dart';
import 'components/text_components/dicetext.dart';
import 'components/text_components/kills.dart';
import 'components/gamelogic.dart';
import 'components/player.dart';

class EileMitWeileGame extends FlameGame with HasTappableComponents {
  late final RouterComponent router;

  @override
  Color backgroundColor() => Color.fromARGB(255, 245, 255, 157);

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

  double screenWidth = 2000;
  double screenHeight = 1600;

  static const double console = 450;

  late final InfoText info_text;
  late final KillInfo kill_text;
  List<Field> fields = [];
  List<Player> players = [];
  List<MoveButton> move_buttons = [];
  DiceText dice_text = DiceText("hans");

  List<int> thrown_dices = [];
  int current_dice = 0;
  bool can_throw_dice = true;

  final world = World();

  Player? current_player;
  Heaven heaven = Heaven();
  int round = 0;
  Dice dice = Dice();

  @override
  Future<void> onLoad() async {
    await Flame.images.load('eilemitweile-sprites.png');
    add(
      router = RouterComponent(
        routes: {
          'game': Route(MainGame.new),
          'victory': Route(VictoryScreen.new, maintainState: false),
          'newgame': Route(NewGameScreen.new),
          'info': Route(InfoScreen.new)
        },
        initialRoute: 'game',
      ),
    );
  }

  void NextPlayer() {
    //Show Kills
    kill_text.text_content = "Kills\nRed: " +
        players[0].bodycount.toString() +
        "\nBlue: " +
        players[1].bodycount.toString() +
        "\nGreen: " +
        players[2].bodycount.toString() +
        "\nPurple: " +
        players[3].bodycount.toString();

    Future.delayed(const Duration(milliseconds: 500), () {
      can_throw_dice = true;
      thrown_dices = [];
      dice_text.text = "";

      final index = players
          .indexWhere((element) => element.color == current_player!.color);
      if (index == 3) {
        round++;
        current_player = players[0];
      } else {
        current_player = players[index + 1];
      }

      info_text.text_content =
          current_player!.name + "\nTurn " + round.toString();

      if (current_player!.is_AI) {
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

    //Move with tokens who are not on a bench/ladder
    for (Token token in current_player!.tokens) {
      if (token.can_move && token.field!.current == FieldState.normal) {
        Move(this, token, dice_number);
        return;
      }
    }

    for (Token token in current_player!.tokens) {
      if (token.can_move && token.field!.number < 69) {
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
