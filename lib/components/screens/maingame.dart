import 'package:EileMitWeile/components/box.dart';
import 'package:EileMitWeile/components/sprites/home_field.dart';
import 'package:EileMitWeile/components/sprites/move_buttons.dart';
import 'package:EileMitWeile/components/token.dart';
import 'package:EileMitWeile/components/gamecreation.dart';
import 'package:flame/components.dart';

import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';

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

    InfoButton infoButton = InfoButton(
        position: Vector2(
            EileMitWeileGame.info_col_size + EileMitWeileGame.fieldHeight,
            gameRef.screenHeight - 140));

    AudioButton audioButton = AudioButton(
        position: Vector2(
            EileMitWeileGame.info_col_size + EileMitWeileGame.fieldHeight + 130,
            gameRef.screenHeight - 140));

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
    box.add(audioButton);

    if (game.is_hotseat) {
      box.add(gameRef.kill_text = KillInfo.killInfo());
      gameRef.kill_text.position =
          Vector2(EileMitWeileGame.console, gameRef.screenHeight - 100);
    } else {
      Sprite info_sprite = emwSprite(628, 841, 330, 330);

      SpriteComponent info_box =
          SpriteComponent(sprite: info_sprite, anchor: Anchor.topLeft);
      info_box.size = Vector2(400, 400);
      info_box.position = Vector2(EileMitWeileGame.info_col_size - 25,
          900 + 3 * EileMitWeileGame.fieldHeight + 25);
      box.add(info_box);

      final style_info = TextStyle(
          color: BasicPalette.black.color,
          fontSize: 35,
          fontFamily: 'PolandFull');

      TextPaint textPaint_info = TextPaint(style: style_info);

      TextComponent round_text = TextComponent(
          text: "Rnd", textRenderer: textPaint_info, anchor: Anchor.center);
      round_text.position = Vector2(EileMitWeileGame.info_col_size + 80,
          900 + 4 * EileMitWeileGame.fieldHeight + 55);
      box.add(round_text);

      gameRef.round_num = TextComponent(
          text: "0", textRenderer: textPaint_info, anchor: Anchor.center);
      gameRef.round_num.position = Vector2(EileMitWeileGame.info_col_size + 245,
          900 + 4 * EileMitWeileGame.fieldHeight + 55);
      box.add(gameRef.round_num);

      gameRef.kill_red = TextComponent(
          text: "0", textRenderer: textPaint_info, anchor: Anchor.center);
      gameRef.kill_red.position = Vector2(EileMitWeileGame.info_col_size + 120,
          900 + 4 * EileMitWeileGame.fieldHeight + 190);
      box.add(gameRef.kill_red);

      gameRef.kill_blue = TextComponent(
          text: "0", textRenderer: textPaint_info, anchor: Anchor.center);
      gameRef.kill_blue.position = Vector2(EileMitWeileGame.info_col_size + 120,
          900 + 4 * EileMitWeileGame.fieldHeight + 290);
      box.add(gameRef.kill_blue);

      gameRef.kill_green = TextComponent(
          text: "0", textRenderer: textPaint_info, anchor: Anchor.center);
      gameRef.kill_green.position = Vector2(
          EileMitWeileGame.info_col_size + 285,
          900 + 4 * EileMitWeileGame.fieldHeight + 290);
      box.add(gameRef.kill_green);

      gameRef.kill_purple = TextComponent(
          text: "0", textRenderer: textPaint_info, anchor: Anchor.center);
      gameRef.kill_purple.position = Vector2(
          EileMitWeileGame.info_col_size + 285,
          900 + 4 * EileMitWeileGame.fieldHeight + 190);
      box.add(gameRef.kill_purple);
    }

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

class InfoButton extends SpriteComponent
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  InfoButton({
    required Vector2 position,
  }) : super(position: position, size: Vector2(100, 100)) {}

  @override
  Future<void> onLoad() async {
    Sprite the_sprite = emwSprite(640, 1183, 70, 70);
    this.sprite = the_sprite;
  }

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.router.pushNamed('info');
  }
}

class AudioButton extends SpriteComponent
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  AudioButton({
    required Vector2 position,
  }) : super(position: position, size: Vector2(100, 100)) {}

  @override
  Future<void> onLoad() async {
    Sprite the_sprite = emwSprite(724, 1183, 70, 70);
    this.sprite = the_sprite;
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (gameRef.audio_enabled) {
      gameRef.audio_enabled = false;
      this.sprite = emwSprite(806, 1183, 70, 70);
    } else {
      gameRef.audio_enabled = true;
      this.sprite = emwSprite(724, 1183, 70, 70);
    }
  }
}
