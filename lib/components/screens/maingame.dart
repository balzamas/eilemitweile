import 'package:EileMitWeile/components/box.dart';
import 'package:EileMitWeile/components/sprites/home_field.dart';
import 'package:EileMitWeile/components/text_components/infotext.dart';
import 'package:EileMitWeile/components/sprites/move_button.dart';
import 'package:EileMitWeile/components/token.dart';
import 'package:EileMitWeile/components/gamecreation.dart';
import 'package:flame/components.dart';

import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

import '../../eilemitweile_game.dart';
import '../../enums.dart';
import '../field.dart';
import '../player.dart';
import '../text_components/kills.dart';

class MainGame extends Component
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  Future<void> onLoad() async {
    gameRef.dice.anchor = Anchor.topCenter;
    gameRef.dice.position =
        Vector2(EileMitWeileGame.console / 2, EileMitWeileGame.fieldHeight);
    gameRef.dice.size = Vector2(362, 1000);

    for (var i = 0; i < 4; i++) {
      MoveButton button = MoveButton();
      button.button_number = i;
      button.position = Vector2(
          EileMitWeileGame.console + 1400 + EileMitWeileGame.fieldHeight,
          EileMitWeileGame.fieldHeight + i * 350);
      button.size = Vector2(350, 350);
      gameRef.move_buttons.add(button);
    }

    gameRef.fields = CreateFields();

    gameRef.players = CreatePlayers();

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

    final style = TextStyle(color: BasicPalette.black.color, fontSize: 40);

    TextPaint textPaint = TextPaint(style: style);

    final yamlString = await rootBundle.loadString('pubspec.yaml');
    final parsedYaml = loadYaml(yamlString);

    TextComponent version = TextComponent(
        text: "Version: " + parsedYaml['version'], textRenderer: textPaint);

    version.position =
        Vector2(gameRef.screenHeight / 2 + 200, gameRef.screenHeight - 100);

    Box box = Box();

    RoundedButton _button1 = RoundedButton(
      text: 'Level 1',
      action: () => gameRef.router.pushNamed('victory'),
      color: const Color(0xffadde6c),
      borderColor: const Color(0xffedffab),
    );

    _button1.position = Vector2(300, 600);

    gameRef.world.add(box);
    gameRef.world.add(version);
    box.addAll(gameRef.players);
    box.addAll(gameRef.fields);
    box.add(gameRef.dice);
    box.add(gameRef.dice_text);
    box.add(gameRef.info_text = InfoText.playerScore());
    box.add(gameRef.kill_text = KillInfo.killInfo());
    box.addAll(home_fields);
    box.addAll(gameRef.move_buttons);
    box.add(gameRef.heaven);
    box.addAll(heaven_fields0);
    box.addAll(heaven_fields1);
    box.addAll(heaven_fields2);
    box.addAll(heaven_fields3);
    box.addAll(tokens);
    //box.add(_button1);

    await add(gameRef.world);

    gameRef.current_player = gameRef.players[3];
    gameRef.info_text.text_content = gameRef.current_player!.name;
    gameRef.players[0].is_AI = false;

    gameRef.dice_text.position = Vector2(EileMitWeileGame.console / 2, 600);
    gameRef.dice_text.anchor = Anchor.center;

    gameRef.NextPlayer();

    final camera = CameraComponent(world: gameRef.world)
      ..viewfinder.visibleGameSize =
          Vector2(gameRef.screenWidth, gameRef.screenHeight)
      ..viewfinder.position = Vector2(1150, 0)
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
    super.anchor = Anchor.center,
  }) : _textDrawable = TextPaint(
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF000000),
            fontWeight: FontWeight.w800,
          ),
        ).toTextPainter(text) {
    size = Vector2(150, 40);

    _textOffset = Offset(
      (size.x - _textDrawable.width) / 2,
      (size.y - _textDrawable.height) / 2,
    );

    _rrect = RRect.fromLTRBR(0, 0, size.x, size.y, Radius.circular(size.y / 2));

    _bgPaint = Paint()..color = color;

    _borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
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
