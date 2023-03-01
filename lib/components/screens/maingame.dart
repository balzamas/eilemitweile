import 'package:EileMitWeile/components/sprites/home_field.dart';
import 'package:EileMitWeile/components/sprites/move_buttons.dart';
import 'package:EileMitWeile/components/token.dart';
import 'package:EileMitWeile/components/gamecreation.dart';
import 'package:flame/components.dart';

import 'package:flame/experimental.dart';

import '../../eilemitweile_game.dart';
import '../../enums.dart';
import '../box_dice.dart';
import '../field.dart';
import '../player.dart';
import '../text_components/state.dart';

class MainGame extends Component
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  Future<void> onLoad() async {
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

    gameRef.fields = CreateFields();

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

    InfoButton infoButton = InfoButton(
        position: Vector2(
            EileMitWeileGame.info_col_size, gameRef.screenHeight - 140));

    AudioButton audioButton = AudioButton(
        position: Vector2(
            EileMitWeileGame.info_col_size + 130, gameRef.screenHeight - 140));

    MenuButton menuButton = MenuButton(
        position: Vector2(
            EileMitWeileGame.info_col_size + 260, gameRef.screenHeight - 140));

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

    gameRef.world.add(gameRef.box);
    //gameRef.world.add(version);
    gameRef.box.addAll(gameRef.players);
    gameRef.box.addAll(gameRef.fields);

    gameRef.box.add(gameRef.state_text_left = State.stateInfo());
    gameRef.box.add(gameRef.state_text_right = State.stateInfo());
    gameRef.box.add(box_dice_left);
    gameRef.box.add(box_dice_right);

    gameRef.box.addAll(home_fields);
    gameRef.box.addAll(gameRef.move_buttons);
    gameRef.box.add(gameRef.heaven);
    gameRef.box.addAll(heaven_fields0);
    gameRef.box.addAll(heaven_fields1);
    gameRef.box.addAll(heaven_fields2);
    gameRef.box.addAll(heaven_fields3);
    gameRef.box.addAll(tokens);
    gameRef.box.add(infoButton);
    gameRef.box.add(audioButton);
    gameRef.box.add(menuButton);

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

    await add(gameRef.world);

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
  }) : super(position: position, size: Vector2(85, 85)) {}

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
  }) : super(position: position, size: Vector2(85, 85)) {}

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

class MenuButton extends SpriteComponent
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  MenuButton({
    required Vector2 position,
  }) : super(position: position, size: Vector2(85, 85)) {}

  @override
  Future<void> onLoad() async {
    Sprite the_sprite = emwSprite(881, 1183, 70, 70);
    this.sprite = the_sprite;
  }

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.router.pushNamed('newgame');
  }
}
