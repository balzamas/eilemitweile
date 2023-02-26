import 'package:EileMitWeile/components/box.dart';
import 'package:EileMitWeile/components/sprites/home_field.dart';
import 'package:EileMitWeile/components/sprites/move_buttons.dart';
import 'package:EileMitWeile/components/token.dart';
import 'package:EileMitWeile/components/gamecreation.dart';
import 'package:flame/components.dart';

import 'package:flame/experimental.dart';

import 'package:flutter/rendering.dart';

import '../../eilemitweile_game.dart';
import '../../enums.dart';
import '../box_dice.dart';
import '../field.dart';
import '../player.dart';
import '../text_components/kills.dart';
import '../text_components/state.dart';

class MainGame extends Component
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  Future<void> onLoad() async {
    int humans = 0;
    for (Player player in gameRef.players) {
      if (!player.is_AI) {
        humans++;
      }
    }

    if (humans > 1) {
      gameRef.is_hotseat = true;
    } else {
      gameRef.is_hotseat = false;
    }

    Sprite movebuttonSprite1 = emwSprite(1150, 0, 332, 332);

    for (var i = 0; i < 4; i++) {
      ButtonComponent button = ButtonComponent(
        position: Vector2(
            EileMitWeileGame.console + 1400 + EileMitWeileGame.fieldHeight,
            EileMitWeileGame.fieldHeight + i * 350),
        sprite: movebuttonSprite1,
      );

      button.button_number = i;

      //button.size = Vector2(350, 350);
      gameRef.move_buttons.add(button);
    }

    if (gameRef.is_hotseat == true) {
      for (var i = 0; i < 4; i++) {
        ButtonComponent button = ButtonComponent(
          position: Vector2(EileMitWeileGame.info_col_size,
              EileMitWeileGame.fieldHeight + i * 350),
          sprite: movebuttonSprite1,
        );

        button.button_number = i;

        //button.size = Vector2(350, 350);
        gameRef.move_buttons.add(button);
      }
    }

    gameRef.fields = CreateFields();

    //gameRef.players = CreatePlayers();

    final List<HomeField> home_fields = [];

    final List<Token> tokens = [];

    // //----Creating Ladders - horrible --------

    final List<Field> heaven_fields0 = [];
    for (var i = 1; i < 8; i++) {
      Field field = Field(fieldst: FieldState.ladder_1);
      field.player = gameRef.players[0];
      field.number = -1;
      field.position = Vector2(
          (EileMitWeileGame.console +
              (8 * EileMitWeileGame.fieldHeight) +
              EileMitWeileGame.fieldWidth),
          gameRef.fields[gameRef.players[0].heaven_start].position.y +
              (i * EileMitWeileGame.fieldHeight));
      heaven_fields0.add(field);
    }
    gameRef.players[0].ladder_fields = heaven_fields0;

    final List<Field> heaven_fields1 = [];
    for (var i = 1; i < 8; i++) {
      Field field = Field(fieldst: FieldState.ladder_2);
      field.angle = 1.57;
      field.isRotated = true;
      field.player = gameRef.players[1];
      field.number = -1;
      field.position = Vector2(
          (gameRef.fields[gameRef.players[1].heaven_start].position.x +
              (i * EileMitWeileGame.fieldHeight)),
          (9 * EileMitWeileGame.fieldHeight) + EileMitWeileGame.fieldWidth);
      heaven_fields1.add(field);
    }
    gameRef.players[1].ladder_fields = heaven_fields1;

    final List<Field> heaven_fields2 = [];
    for (var i = 1; i < 8; i++) {
      Field field = Field(fieldst: FieldState.ladder_3);
      field.player = gameRef.players[2];
      field.number = -1;
      field.position = Vector2(
          (EileMitWeileGame.console +
              (8 * EileMitWeileGame.fieldHeight) +
              EileMitWeileGame.fieldWidth),
          gameRef.fields[gameRef.players[2].heaven_start].position.y -
              (i * EileMitWeileGame.fieldHeight));
      heaven_fields2.add(field);
    }
    gameRef.players[2].ladder_fields = heaven_fields2;

    final List<Field> heaven_fields3 = [];
    for (var i = 1; i < 8; i++) {
      Field field = Field(fieldst: FieldState.ladder_4);
      field.angle = 1.57;
      field.isRotated = true;
      field.player = gameRef.players[3];
      field.number = -1;
      field.position = Vector2(
          (gameRef.fields[gameRef.players[3].heaven_start].position.x -
              (i * EileMitWeileGame.fieldHeight)),
          (9 * EileMitWeileGame.fieldHeight) + EileMitWeileGame.fieldWidth);
      heaven_fields3.add(field);
    }
    gameRef.players[3].ladder_fields = heaven_fields3;

    //----------------------------------------

    gameRef.heaven.position = Vector2(
        EileMitWeileGame.console + 8 * EileMitWeileGame.fieldHeight,
        8 * EileMitWeileGame.fieldHeight + EileMitWeileGame.fieldHeight);

    for (Player player in gameRef.players) {
      HomeField home_field1 = HomeField();
      home_field1.player = player;
      home_field1.position =
          Vector2(player.home_x, player.home_y + EileMitWeileGame.fieldHeight);
      home_fields.add(home_field1);

      HomeField home_field2 = HomeField();
      home_field2.player = player;
      home_field2.position = Vector2(
          player.home_x + 200, player.home_y + EileMitWeileGame.fieldHeight);
      home_fields.add(home_field2);

      HomeField home_field3 = HomeField();
      home_field3.player = player;
      home_field3.position = Vector2(
          player.home_x, player.home_y + 200 + EileMitWeileGame.fieldHeight);
      home_fields.add(home_field3);

      HomeField home_field4 = HomeField();
      home_field4.player = player;
      home_field4.position = Vector2(player.home_x + 200,
          player.home_y + 200 + EileMitWeileGame.fieldHeight);
      home_fields.add(home_field4);

      for (var i = 0; i < 4; i++) {
        Token token = Token(player);
        token.size = gameRef.tokenSize;
        token.field = gameRef.fields[0];
        token.token_number = i;
        tokens.add(token);
        player.tokens.add(token);
        switch (i) {
          case 0:
            {
              token.position = Vector2(token.player.home_x + 75,
                  token.player.home_y + 75 + EileMitWeileGame.tokenHeight);
            }
            break;

          case 1:
            {
              token.position = Vector2(token.player.home_x + 275,
                  token.player.home_y + 75 + EileMitWeileGame.tokenHeight);
            }
            break;

          case 2:
            {
              token.position = Vector2(token.player.home_x + 75,
                  token.player.home_y + 275 + EileMitWeileGame.tokenHeight);
            }
            break;

          case 3:
            {
              token.position = Vector2(token.player.home_x + 275,
                  token.player.home_y + 275 + EileMitWeileGame.tokenHeight);
            }
            break;
        }
      }
    }

    Box box = Box();

    RoundedButton infoButton = RoundedButton(
      text: 'Info',
      action: () => gameRef.router.pushNamed('info'),
      color: Color.fromARGB(255, 238, 255, 0),
      borderColor: Color.fromARGB(255, 0, 0, 0),
    );

    infoButton.position = Vector2(
        EileMitWeileGame.console + 1400 + EileMitWeileGame.fieldHeight,
        gameRef.screenHeight - 100);

    gameRef.heaven.size = Vector2(600, 600);

    BoxDice box_dice_left = BoxDice();
    BoxDice box_dice_right = BoxDice();

    box_dice_left.position = Vector2(
        EileMitWeileGame.info_col_size / 2 - 20, gameRef.screenHeight / 2);

    box_dice_right.position = Vector2(
        EileMitWeileGame.console +
            1400 +
            EileMitWeileGame.button_size +
            EileMitWeileGame.info_col_size / 2 +
            20,
        gameRef.screenHeight / 2);

    gameRef.world.add(box);
    //gameRef.world.add(version);
    box.addAll(gameRef.players);
    box.addAll(gameRef.fields);

    box.add(gameRef.kill_text = KillInfo.killInfo());
    box.add(gameRef.state_text_left = State.stateInfo());
    box.add(gameRef.state_text_right = State.stateInfo());
    box.add(box_dice_left);
    box.add(box_dice_right);

    box.addAll(home_fields);
    box.addAll(gameRef.move_buttons);
    box.add(gameRef.heaven);
    box.addAll(heaven_fields0);
    box.addAll(heaven_fields1);
    box.addAll(heaven_fields2);
    box.addAll(heaven_fields3);
    box.addAll(tokens);
    box.add(infoButton);

    gameRef.kill_text.position =
        Vector2(EileMitWeileGame.console, gameRef.screenHeight - 100);

    // if (gameRef.is_hotseat) {
    //   gameRef.kill_text.position =
    //       Vector2(EileMitWeileGame.console, gameRef.screenHeight - 100);
    // } else {
    //   gameRef.kill_text.position = Vector2(EileMitWeileGame.info_col_size,
    //       4 * EileMitWeileGame.fieldHeight + 1200);
    // }

    gameRef.state_text_left.position = Vector2(
        EileMitWeileGame.info_col_size / 2 - 20, gameRef.screenHeight / 2);

    gameRef.state_text_right.is_right = true;
    gameRef.state_text_right.position = Vector2(
        EileMitWeileGame.console +
            1400 +
            EileMitWeileGame.button_size +
            EileMitWeileGame.info_col_size / 2 +
            20,
        gameRef.screenHeight / 2);

    gameRef.move_buttons[1].setPlayerColor(1);
    gameRef.move_buttons[2].setPlayerColor(2);
    gameRef.move_buttons[3].setPlayerColor(3);
    if (gameRef.is_hotseat == true) {
      gameRef.move_buttons[5].setPlayerColor(1);
      gameRef.move_buttons[6].setPlayerColor(2);
      gameRef.move_buttons[7].setPlayerColor(3);
    }
    await add(gameRef.world);

    gameRef.current_player = gameRef.players[3];
    //gameRef.players[0].is_AI = false;

    gameRef.NextPlayer();

    final camera = CameraComponent(world: gameRef.world)
      ..viewfinder.visibleGameSize =
          Vector2(gameRef.screenWidth, gameRef.screenHeight)
      ..viewfinder.position = Vector2(1555, 0)
      ..viewfinder.anchor = Anchor.topCenter;
    add(camera);
  }
}

class RoundedButton extends PositionComponent with TapCallbacks {
  RoundedButton({
    required this.text,
    required this.action,
    required Color color,
    required Color borderColor,
    super.anchor = Anchor.centerLeft,
  }) : _textDrawable = TextPaint(
          style: const TextStyle(
            fontSize: 50,
            color: Color(0xFF000000),
            fontWeight: FontWeight.w800,
            fontFamily: 'Komika',
          ),
        ).toTextPainter(text) {
    size = Vector2(150, 70);

    _textOffset = Offset(
      (size.x - _textDrawable.width) / 2,
      (size.y - _textDrawable.height) / 2,
    );

    _rrect = RRect.fromLTRBR(0, 0, size.x, size.y, Radius.circular(size.y / 6));

    _bgPaint = Paint()..color = color;

    _borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = borderColor;
  }

  final String text;

  final void Function() action;

  final TextPainter _textDrawable;

  late final Offset _textOffset;

  late final RRect _rrect;

  late final Paint _borderPaint;

  late final Paint _bgPaint;

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rrect, _bgPaint);

    canvas.drawRRect(_rrect, _borderPaint);

    _textDrawable.paint(canvas, _textOffset);
  }

  @override
  void onTapDown(TapDownEvent event) {
    scale = Vector2.all(1.05);
  }

  @override
  void onTapUp(TapUpEvent event) {
    scale = Vector2.all(1.0);

    action();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    scale = Vector2.all(1.0);
  }
}
