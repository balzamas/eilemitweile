import 'package:EileMitWeile/components/box.dart';
import 'package:EileMitWeile/components/sprites/dice.dart';
import 'package:EileMitWeile/components/sprites/heaven.dart';
import 'package:EileMitWeile/components/sprites/home_field.dart';
import 'package:EileMitWeile/components/text_components/infotext.dart';
import 'package:EileMitWeile/components/sprites/move_button.dart';
import 'package:EileMitWeile/components/token.dart';
import 'package:EileMitWeile/components/gamecreation.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

import 'components/text_components/dicenumber.dart';
import 'components/field.dart';
import 'components/text_components/kills.dart';
import 'components/gamelogic.dart';
import 'components/player.dart';
import 'enums.dart';

class EilemitweileGame extends FlameGame with HasTappableComponents {
  @override
  Color backgroundColor() => Color.fromARGB(255, 245, 255, 157);

  static const double fieldWidth = 200.0;
  static const double fieldHeight = 50.0;
  static final Vector2 fieldSizeVert = Vector2(fieldWidth, fieldHeight);
  static final Vector2 fieldSizeHoe = Vector2(fieldHeight, fieldWidth);
  static const double fieldRadius = 100.0;

  static const double tokenWidth = 50.0;
  static const double tokenHeight = 50.0;
  static final Vector2 tokenSize = Vector2(tokenWidth, tokenHeight);

  static const double screenWidth = 2000;
  static const double screenHeight = 1600;

  static final double console = 450;

  late final ScoreText dice_text;
  late final InfoText info_text;
  late final KillInfo kill_text;
  List<Field> fields = [];
  List<Player> players = [];
  List<MoveButton> move_buttons = [];

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

    dice.position = Vector2(10, 50);
    dice.size = Vector2(400, 1000);

    for (var i = 0; i < 4; i++) {
      MoveButton button = MoveButton();
      button.button_number = i;
      button.position =
          Vector2(console + 1400 + fieldHeight, fieldHeight + i * 350);
      button.size = Vector2(350, 350);
      move_buttons.add(button);
    }

    fields = CreateFields();

    players = CreatePlayers();

    final List<HomeField> home_fields = [];

    final List<Token> tokens = [];

    // //----Creating Ladders - horrible --------

    final List<Field> heaven_fields0 = [];
    for (var i = 1; i < 8; i++) {
      Field field = Field(fieldst: FieldState.ladder_1);
      field.player = players[0];
      field.number = -1;
      field.position = Vector2((console + (8 * fieldHeight) + fieldWidth),
          fields[players[0].heaven_start].position.y + (i * fieldHeight));
      heaven_fields0.add(field);
    }
    players[0].ladder_fields = heaven_fields0;

    final List<Field> heaven_fields1 = [];
    for (var i = 1; i < 8; i++) {
      Field field = Field(fieldst: FieldState.ladder_2);
      field.angle = 1.57;
      field.isRotated = true;
      field.player = players[1];
      field.number = -1;
      field.position = Vector2(
          (fields[players[1].heaven_start].position.x + (i * fieldHeight)),
          (9 * fieldHeight) + fieldWidth);
      heaven_fields1.add(field);
    }
    players[1].ladder_fields = heaven_fields1;

    final List<Field> heaven_fields2 = [];
    for (var i = 1; i < 8; i++) {
      Field field = Field(fieldst: FieldState.ladder_3);
      field.player = players[2];
      field.number = -1;
      field.position = Vector2((console + (8 * fieldHeight) + fieldWidth),
          fields[players[2].heaven_start].position.y - (i * fieldHeight));
      heaven_fields2.add(field);
    }
    players[2].ladder_fields = heaven_fields2;

    final List<Field> heaven_fields3 = [];
    for (var i = 1; i < 8; i++) {
      Field field = Field(fieldst: FieldState.ladder_4);
      field.angle = 1.57;
      field.isRotated = true;
      field.player = players[3];
      field.number = -1;
      field.position = Vector2(
          (fields[players[3].heaven_start].position.x - (i * fieldHeight)),
          (9 * fieldHeight) + fieldWidth);
      heaven_fields3.add(field);
    }
    players[3].ladder_fields = heaven_fields3;

    //----------------------------------------

    heaven.position =
        Vector2(console + 8 * fieldHeight, 8 * fieldHeight + fieldHeight);

    for (Player player in players) {
      HomeField home_field1 = HomeField();
      home_field1.player = player;
      home_field1.position =
          Vector2(player.home_x, player.home_y + fieldHeight);
      home_fields.add(home_field1);

      HomeField home_field2 = HomeField();
      home_field2.player = player;
      home_field2.position =
          Vector2(player.home_x + 200, player.home_y + fieldHeight);
      home_fields.add(home_field2);

      HomeField home_field3 = HomeField();
      home_field3.player = player;
      home_field3.position =
          Vector2(player.home_x, player.home_y + 200 + fieldHeight);
      home_fields.add(home_field3);

      HomeField home_field4 = HomeField();
      home_field4.player = player;
      home_field4.position =
          Vector2(player.home_x + 200, player.home_y + 200 + fieldHeight);
      home_fields.add(home_field4);

      for (var i = 0; i < 4; i++) {
        Token token = Token(player);
        token.size = tokenSize;
        token.field = fields[0];
        token.token_number = i;
        tokens.add(token);
        player.tokens.add(token);
        switch (i) {
          case 0:
            {
              token.position = Vector2(token.player.home_x + 75,
                  token.player.home_y + 75 + EilemitweileGame.tokenHeight);
            }
            break;

          case 1:
            {
              token.position = Vector2(token.player.home_x + 275,
                  token.player.home_y + 75 + EilemitweileGame.tokenHeight);
            }
            break;

          case 2:
            {
              token.position = Vector2(token.player.home_x + 75,
                  token.player.home_y + 275 + EilemitweileGame.tokenHeight);
            }
            break;

          case 3:
            {
              token.position = Vector2(token.player.home_x + 275,
                  token.player.home_y + 275 + EilemitweileGame.tokenHeight);
            }
            break;
        }
      }
    }

    final style = TextStyle(color: BasicPalette.black.color, fontSize: 40);

    TextPaint textPaint = TextPaint(style: style);

    final yamlString = await rootBundle.loadString('pubspec.yaml');
    final parsedYaml = loadYaml(yamlString);

    TextComponent version = TextComponent(
        text: "Version: " + parsedYaml['version'], textRenderer: textPaint);

    version.position = Vector2(EilemitweileGame.screenHeight / 2 + 200,
        EilemitweileGame.screenHeight - 100);

    Box box = Box();

    world.add(box);
    world.add(version);
    box.addAll(players);
    box.addAll(fields);
    box.add(dice);
    box.add(dice_text = ScoreText.playerScore());
    box.add(info_text = InfoText.playerScore());
    box.add(kill_text = KillInfo.killInfo());
    box.addAll(home_fields);
    box.addAll(move_buttons);
    box.add(heaven);
    box.addAll(heaven_fields0);
    box.addAll(heaven_fields1);
    box.addAll(heaven_fields2);
    box.addAll(heaven_fields3);
    box.addAll(tokens);

    await add(world);

    current_player = players[3];
    info_text.text_content = current_player!.name;
    NextPlayer();
    players[0].is_AI = false;

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = Vector2(screenWidth, screenHeight)
      ..viewfinder.position = Vector2(1150, 0)
      ..viewfinder.anchor = Anchor.topCenter;
    add(camera);
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
      dice_text.text_content = "";

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
              if (token.last_round_moved == this.round) {
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
    if (dice_number == 5) {
      for (Token token in current_player!.tokens) {
        if (token.can_move && token.field!.number == 0) {
          Move(this, token, dice_number);
          return;
        }
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
}

Sprite emwSprite(double x, double y, double width, double height) {
  return Sprite(
    Flame.images.fromCache('eilemitweile-sprites.png'),
    srcPosition: Vector2(x, y),
    srcSize: Vector2(width, height),
  );
}
