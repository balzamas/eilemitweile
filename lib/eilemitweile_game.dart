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
import 'package:shared_preferences/shared_preferences.dart';

import 'components/box.dart';
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

  Rectangle status_bar_red = Rectangle(
      Paint()..color = Color.fromARGB(255, 255, 0, 0),
      EileMitWeileGame.console,
      1 * EileMitWeileGame.fieldHeight,
      140);

  Rectangle status_bar_blue = Rectangle(
      Paint()..color = Color.fromARGB(255, 17, 0, 255),
      EileMitWeileGame.console,
      16 * EileMitWeileGame.fieldHeight + 3 * EileMitWeileGame.fieldWidth + 30,
      140);

  Rectangle status_bar_green = Rectangle(
      Paint()..color = Color.fromARGB(255, 0, 146, 0),
      EileMitWeileGame.console +
          8 * EileMitWeileGame.fieldHeight +
          3 * EileMitWeileGame.fieldWidth,
      16 * EileMitWeileGame.fieldHeight + 3 * EileMitWeileGame.fieldWidth + 30,
      140);

  Rectangle status_bar_purple = Rectangle(
      Paint()..color = Color.fromARGB(255, 155, 0, 142),
      EileMitWeileGame.console +
          8 * EileMitWeileGame.fieldHeight +
          3 * EileMitWeileGame.fieldWidth,
      1 * EileMitWeileGame.fieldHeight,
      140);

  KillInfo kill_text = KillInfo.killInfo();
  late final StateButton state_text_left;
  late final StateButton state_text_right;

  late InfoButton infoButton = InfoButton(
      position: Vector2(EileMitWeileGame.info_col_size, screenHeight - 140));
  late AudioButton audioButton = AudioButton(
      position:
          Vector2(EileMitWeileGame.info_col_size + 130, screenHeight - 140));
  late MenuButton menuButton = MenuButton(
      position:
          Vector2(EileMitWeileGame.info_col_size + 260, screenHeight - 140));

  late TextComponent round_num;
  late TextComponent round_text;

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

  Box box = Box();
  late Sprite info_sprite;
  late SpriteComponent info_box = SpriteComponent(anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    await FlameAudio.audioCache.loadAll([
      'kill/kill_1.wav',
      'kill/kill_2.wav',
      'kill/kill_3.wav',
      'kill/kill_4.wav',
      'kill/kill_5.wav',
      'kill/kill_6.wav',
      'kill/kill_7.wav',
      'kill/kill_8.wav',
      'kill/kill_9.wav',
      'kill/kill_10.wav',
      'kill/kill_11.wav',
      'kill/kill_12.wav',
      'kill/kill_13.wav',
      'kill/kill_14.wav',
      'kill/kill_15.wav',
      'kill/kill_16.wav',
      'kill/kill_17.wav',
      'kill/kill_18.wav',
      'start/start_1.wav',
      'start/start_2.wav',
      'start/start_3.wav',
      'start/start_4.wav',
      'start/start_5.wav',
      'start/start_6.wav',
      'start/start_7.wav',
      'start/start_8.wav',
      'start/start_9.wav',
      'start/start_10.wav',
      'start/start_11.wav',
      'triple6/triple6_1.wav',
      'triple6/triple6_2.wav',
      'triple6/triple6_3.wav',
      'dice.wav',
      'gameover.wav',
      'move_1.wav',
      'wow.wav',
      'menu.wav'
    ]);

    await Flame.images.load('eilemitweile-sprites.png');
    info_sprite = emwSprite(628, 841, 330, 330);
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
    //Can token kill leading player?
    for (Token token in current_player!.tokens) {
      if (token.can_move &&
          token.field!.number < 69 &&
          CheckForPrey(this, token, dice_number, true)) {
        Move(this, token, dice_number);
        return;
      }
    }

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
          CheckForPrey(this, token, dice_number, false)) {
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

  void DrawUI() {
    Sprite movebuttonSprite1 = emwSprite(1150, 0, 332, 332);

    if (is_hotseat) {
      if (move_buttons.length != 8) {
        for (var i = 0; i < 4; i++) {
          ButtonComponent button = ButtonComponent(
            position: Vector2(EileMitWeileGame.info_col_size,
                EileMitWeileGame.fieldHeight + i * 350),
            sprite: movebuttonSprite1,
          );

          button.button_number = i;

          //button.size = Vector2(350, 350);
          move_buttons.add(button);
        }

        for (var i = 4; i < 8; i++) {
          box.add(move_buttons[i]);
        }
      }
    } else {
      if (move_buttons.length == 8) {
        for (var i = 4; i < 8; i++) {
          if (box.contains(move_buttons[i])) {
            box.remove(move_buttons[i]);
          }
        }
      }
    }

    if (is_hotseat) {
      if (box.contains(info_box)) {
        box.remove(info_box);
        box.remove(round_text);
        box.remove(round_num);
      }

      if (!box.contains(kill_text)) {
        box.add(kill_text);
        kill_text.position =
            Vector2(EileMitWeileGame.console, screenHeight - 100);
      }
    } else {
      if (box.contains(kill_text)) {
        box.remove(kill_text);
      }

      SpriteComponent kill_icon_red = SpriteComponent();
      Sprite kill_icon_red_sprite = emwSprite(512, 325, 58, 58);
      kill_icon_red.anchor = Anchor.center;
      kill_icon_red.sprite = kill_icon_red_sprite;
      kill_icon_red.size = Vector2(58, 58);
      kill_icon_red.position = Vector2(
          EileMitWeileGame.console + 3 * EileMitWeileGame.fieldHeight,
          5 * EileMitWeileGame.fieldHeight);
      box.add(kill_icon_red);

      SpriteComponent kill_icon_blue = SpriteComponent();
      Sprite kill_icon_blue_sprite = emwSprite(512, 447, 58, 58);
      kill_icon_blue.anchor = Anchor.center;
      kill_icon_blue.sprite = kill_icon_blue_sprite;
      kill_icon_blue.size = Vector2(58, 58);
      kill_icon_blue.position = Vector2(
          EileMitWeileGame.console + 3 * EileMitWeileGame.fieldHeight,
          13 * EileMitWeileGame.fieldHeight + 3 * EileMitWeileGame.fieldWidth);
      box.add(kill_icon_blue);

      SpriteComponent kill_icon_green = SpriteComponent();
      Sprite kill_icon_green_sprite = emwSprite(512, 509, 58, 58);
      kill_icon_green.anchor = Anchor.center;
      kill_icon_green.sprite = kill_icon_green_sprite;
      kill_icon_green.size = Vector2(58, 58);
      kill_icon_green.position = Vector2(
          EileMitWeileGame.console +
              11 * EileMitWeileGame.fieldHeight +
              3 * EileMitWeileGame.fieldWidth,
          13 * EileMitWeileGame.fieldHeight + 3 * EileMitWeileGame.fieldWidth);
      box.add(kill_icon_green);

      SpriteComponent kill_icon_purple = SpriteComponent();
      Sprite kill_icon_purple_sprite = emwSprite(512, 386, 58, 58);
      kill_icon_purple.anchor = Anchor.center;
      kill_icon_purple.sprite = kill_icon_purple_sprite;
      kill_icon_purple.size = Vector2(58, 58);
      kill_icon_purple.position = Vector2(
          EileMitWeileGame.console +
              11 * EileMitWeileGame.fieldHeight +
              3 * EileMitWeileGame.fieldWidth,
          5 * EileMitWeileGame.fieldHeight);
      box.add(kill_icon_purple);

      if (!box.contains(info_box)) {
        info_box.sprite = info_sprite;
        info_box.size = Vector2(400, 400);
        info_box.position = Vector2(EileMitWeileGame.info_col_size - 25,
            900 + 3 * EileMitWeileGame.fieldHeight + 25);
        box.add(info_box);

        final style_info = TextStyle(
            color: BasicPalette.black.color,
            fontSize: 35,
            fontFamily: 'PolandFull');

        TextPaint textPaint_info = TextPaint(style: style_info);

        round_text = TextComponent(
            text: "Rnd", textRenderer: textPaint_info, anchor: Anchor.center);
        round_text.position = Vector2(EileMitWeileGame.info_col_size + 80,
            900 + 4 * EileMitWeileGame.fieldHeight + 55);
        box.add(round_text);

        round_num = TextComponent(
            text: "0", textRenderer: textPaint_info, anchor: Anchor.center);
        round_num.position = Vector2(EileMitWeileGame.info_col_size + 245,
            900 + 4 * EileMitWeileGame.fieldHeight + 55);
        box.add(round_num);

        kill_red = TextComponent(
            text: "0", textRenderer: textPaint_info, anchor: Anchor.center);
        kill_red.position = Vector2(
            EileMitWeileGame.console + 5 * EileMitWeileGame.fieldHeight,
            5 * EileMitWeileGame.fieldHeight + 10);
        box.add(kill_red);

        kill_blue = TextComponent(
            text: "0", textRenderer: textPaint_info, anchor: Anchor.center);
        kill_blue.position = Vector2(
            EileMitWeileGame.console + 5 * EileMitWeileGame.fieldHeight,
            13 * EileMitWeileGame.fieldHeight +
                3 * EileMitWeileGame.fieldWidth +
                10);
        box.add(kill_blue);

        kill_green = TextComponent(
            text: "0", textRenderer: textPaint_info, anchor: Anchor.center);
        kill_green.position = Vector2(
            EileMitWeileGame.console +
                13 * EileMitWeileGame.fieldHeight +
                3 * EileMitWeileGame.fieldWidth,
            13 * EileMitWeileGame.fieldHeight +
                3 * EileMitWeileGame.fieldWidth +
                10);
        box.add(kill_green);

        kill_purple = TextComponent(
            text: "0", textRenderer: textPaint_info, anchor: Anchor.center);
        kill_purple.position = Vector2(
            EileMitWeileGame.console +
                13 * EileMitWeileGame.fieldHeight +
                3 * EileMitWeileGame.fieldWidth,
            5 * EileMitWeileGame.fieldHeight + 10);
        box.add(kill_purple);
      }
    }

    if (is_hotseat) {
      infoButton.position =
          Vector2(EileMitWeileGame.info_col_size, screenHeight - 140);

      audioButton.position =
          Vector2(EileMitWeileGame.info_col_size + 130, screenHeight - 140);

      menuButton.position =
          Vector2(EileMitWeileGame.info_col_size + 260, screenHeight - 140);
    } else {
      infoButton.position =
          Vector2(EileMitWeileGame.info_col_size, screenHeight - 320);

      audioButton.position =
          Vector2(EileMitWeileGame.info_col_size + 120, screenHeight - 320);

      menuButton.position =
          Vector2(EileMitWeileGame.info_col_size + 240, screenHeight - 320);
    }

    if (!box.contains(infoButton)) {
      box.add(infoButton);
      box.add(menuButton);
      box.add(audioButton);
    }

    if (box.contains(status_bar_red)) {
      box.remove(status_bar_red);
      box.remove(status_bar_blue);
      box.remove(status_bar_green);
      box.remove(status_bar_purple);
    }

    Paint red = Paint()..color = Color.fromARGB(255, 255, 0, 0);
    status_bar_red = Rectangle(
        red, EileMitWeileGame.console, 1 * EileMitWeileGame.fieldHeight, 140);

    Paint blue = Paint()..color = Color.fromARGB(255, 17, 0, 255);
    status_bar_blue = Rectangle(
        blue,
        EileMitWeileGame.console,
        16 * EileMitWeileGame.fieldHeight +
            3 * EileMitWeileGame.fieldWidth +
            30,
        140);

    Paint green = Paint()..color = Color.fromARGB(255, 0, 146, 0);
    status_bar_green = Rectangle(
        green,
        EileMitWeileGame.console +
            8 * EileMitWeileGame.fieldHeight +
            3 * EileMitWeileGame.fieldWidth,
        16 * EileMitWeileGame.fieldHeight +
            3 * EileMitWeileGame.fieldWidth +
            30,
        140);

    Paint purple = Paint()..color = Color.fromARGB(255, 155, 0, 142);
    status_bar_purple = Rectangle(
        purple,
        EileMitWeileGame.console +
            8 * EileMitWeileGame.fieldHeight +
            3 * EileMitWeileGame.fieldWidth,
        1 * EileMitWeileGame.fieldHeight,
        140);

    if (!box.contains(status_bar_red)) {
      box.add(status_bar_red);

      box.add(status_bar_blue);

      box.add(status_bar_green);
      box.add(status_bar_purple);
    }

    status_bar_red.length = 0;
    status_bar_blue.length = 0;
    status_bar_purple.length = 0;
    status_bar_green.length = 0;

    // move_buttons[1].setPlayerColor(1);
    // move_buttons[2].setPlayerColor(2);
    // move_buttons[3].setPlayerColor(3);
    // if (is_hotseat == true) {
    //   move_buttons[5].setPlayerColor(1);
    //   move_buttons[6].setPlayerColor(2);
    //   move_buttons[7].setPlayerColor(3);
    // }
  }

  void NewGame() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      round = 0;
      for (Player player in players) {
        player.bodycount = 0;
        player.score = 0;
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

    if (!gameRef.audio_enabled) {
      the_sprite = emwSprite(806, 1183, 70, 75);
    }

    this.sprite = the_sprite;
  }

  @override
  void onTapUp(TapUpEvent event) async {
    if (gameRef.audio_enabled) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('audio', false);

      gameRef.audio_enabled = false;
      this.sprite = emwSprite(806, 1183, 70, 75);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('audio', true);
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

class Rectangle extends PositionComponent {
  Paint color;
  double left;
  double top;
  double length;

  Rectangle(this.color, this.left, this.top, this.length);

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(left, top, length, 20), color);
  }
}
