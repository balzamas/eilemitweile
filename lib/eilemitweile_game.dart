import 'dart:io';
import 'dart:ui';

import 'package:EileMitWeile/components/dice.dart';
import 'package:EileMitWeile/components/heaven.dart';
import 'package:EileMitWeile/components/home_field.dart';
import 'package:EileMitWeile/components/infotext.dart';
import 'package:EileMitWeile/components/move_button.dart';
import 'package:EileMitWeile/components/tokens.dart';
import 'package:EileMitWeile/playfield.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

import 'components/dicenumber.dart';
import 'components/field.dart';
import 'components/kills.dart';
import 'components/movement.dart';
import 'components/player.dart';
import 'enums.dart';

class EilemitweileGame extends FlameGame with HasTappableComponents {
  @override
  Color backgroundColor() => Color.fromARGB(255, 207, 232, 245);

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

  late final ScoreText last_throw;
  late final InfoText info_text;
  late final KillInfo kill_text;
  List<Field> fields = [];
  List<Player> players = [];
  List<MoveButton> move_buttons = [];

  final world = World();

  Player? current_player;
  Heaven heaven = Heaven();
  int round = 1;
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

    fields = createFields();

    players = createPlayers();

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

    version.position = Vector2(0, EilemitweileGame.screenHeight - 100);

    world.add(version);

    world.addAll(players);
    world.addAll(fields);
    world.add(dice);
    world.add(last_throw = ScoreText.playerScore());
    world.add(info_text = InfoText.playerScore());
    world.add(kill_text = KillInfo.killInfo());
    world.addAll(home_fields);
    world.addAll(move_buttons);
    world.add(heaven);
    world.addAll(heaven_fields0);
    world.addAll(heaven_fields1);
    world.addAll(heaven_fields2);
    world.addAll(heaven_fields3);
    world.addAll(tokens);

    await add(world);

    current_player = players[0];
    info_text.text_content = current_player!.name;
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
      last_throw.last_throw = 0;

      final index = players
          .indexWhere((element) => element.color == current_player!.color);
      if (index == 3) {
        round++;
        current_player = players[0];
      } else {
        current_player = players[index + 1];
      }

      info_text.text_content =
          current_player!.name + "\n\nTurn " + round.toString();

      if (current_player!.is_AI) {
        Future.delayed(const Duration(milliseconds: 500), () {
          ThrowDice(this);
          if (current_player!.has_moveable_token) {
            Move_KI();
          }
        });
      }
    });
  }

  void Move_KI() {
    if (last_throw.last_throw == 5) {
      for (Token token in current_player!.tokens) {
        if (token.can_move && token.field!.number == 0) {
          Move(this, token);
          return;
        }
      }
    }
    for (Token token in current_player!.tokens) {
      if (token.can_move && token.field!.number < 69) {
        Move(this, token);
        return;
      }
    }
    for (Token token in current_player!.tokens) {
      if (token.can_move) {
        Move(this, token);
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
