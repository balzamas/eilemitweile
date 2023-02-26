import 'dart:async';

import 'package:EileMitWeile/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';

import '../../eilemitweile_game.dart';
import '../gamecreation.dart';

final style_small = TextStyle(
    color: BasicPalette.black.color, fontSize: 40, fontFamily: 'Komika');

TextPaint textPaint_small = TextPaint(style: style_small);

TextComponent player1_opt = TextComponent(
    text: "Human", textRenderer: textPaint_small, anchor: Anchor.center);

TextComponent player2_opt = TextComponent(
    text: "KI", textRenderer: textPaint_small, anchor: Anchor.center);

TextComponent player3_opt = TextComponent(
    text: "KI", textRenderer: textPaint_small, anchor: Anchor.center);

TextComponent player4_opt = TextComponent(
    text: "KI", textRenderer: textPaint_small, anchor: Anchor.center);

class NewGameScreen extends Component
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {
    gameRef.players = CreatePlayers();

    Vector2 scale = Vector2(
        game.size.x / gameRef.screenWidth, game.size.x / gameRef.screenWidth);

    final style_large = TextStyle(
        color: BasicPalette.black.color, fontSize: 60, fontFamily: 'Komika');

    TextPaint textPaint_large = TextPaint(style: style_large);

    TextComponent title = TextComponent(
        text: "New game", textRenderer: textPaint_large, anchor: Anchor.center);
    title.position = Vector2(game.size.x / 2, scale.x * 125);
    title.scale = scale;

    //add(title);

    Sprite fild_img = emwSprite(624, 326, 500, 500);

    SpriteComponent field =
        SpriteComponent(sprite: fild_img, anchor: Anchor.center);
    field.anchor = Anchor.topCenter;
    field.size = Vector2(game.size.x / 3 - 80, game.size.x / 3 - 80);
    field.position = Vector2(game.size.x / 2, 100);
    add(field);

    Player player1 = Player();
    player1.color = 1;

    Player player4 = Player();
    player4.color = 4;

    Player player2 = Player();
    player2.color = 2;

    Player player3 = Player();
    player3.color = 3;

    RoundedButton player1_btn = RoundedButton(
        text: '',
        action: () => gameRef.router.pushNamed('info'),
        color: Color.fromARGB(255, 245, 110, 110),
        borderColor: Color.fromARGB(255, 0, 0, 0),
        game: game,
        id: 0);

    player1_btn.position = Vector2(20 + (game.size.x / 3 / 2), 100);
    player1_opt.position = Vector2(
        20 + (game.size.x / 3 / 2), 100 + (game.size.x / 3 - 80) / 3 / 2);

    add(player1_btn);

    RoundedButton player2_btn = RoundedButton(
        text: '',
        action: () => gameRef.router.pushNamed('info'),
        color: Color.fromARGB(255, 155, 162, 250),
        borderColor: Color.fromARGB(255, 0, 0, 0),
        game: game,
        id: 1);

    player2_btn.position = Vector2(
        20 + (game.size.x / 3 / 2), (game.size.x / 3 - 80) / 3 * 2 + 100);
    player2_opt.position = Vector2(20 + (game.size.x / 3 / 2),
        (game.size.x / 3 - 80) / 3 * 2 + 100 + (game.size.x / 3 - 80) / 3 / 2);

    add(player2_btn);

    RoundedButton player3_btn = RoundedButton(
        text: '',
        action: () => gameRef.router.pushNamed('info'),
        color: Color.fromARGB(255, 160, 250, 160),
        borderColor: Color.fromARGB(255, 0, 0, 0),
        game: game,
        id: 2);

    player3_btn.position = Vector2(
        (2 * (game.size.x / 3)) + (game.size.x / 3 / 2) - 20,
        (game.size.x / 3 - 80) / 3 * 2 + 100);
    player3_opt.position = Vector2(
        (2 * (game.size.x / 3)) + (game.size.x / 3 / 2) - 20,
        (game.size.x / 3 - 80) / 3 * 2 + 100 + (game.size.x / 3 - 80) / 3 / 2);

    add(player3_btn);

    RoundedButton player4_btn = RoundedButton(
        text: '',
        action: () => gameRef.router.pushNamed('info'),
        color: Color.fromARGB(255, 241, 136, 255),
        borderColor: Color.fromARGB(255, 0, 0, 0),
        game: game,
        id: 3);

    player4_btn.position =
        Vector2((2 * (game.size.x / 3)) + (game.size.x / 3 / 2) - 20, 100);
    player4_opt.position = Vector2(
        (2 * (game.size.x / 3)) + (game.size.x / 3 / 2) - 20,
        100 + (game.size.x / 3 - 80) / 3 / 2);

    add(player4_btn);

    BoxStart boxs = BoxStart();
    boxs.anchor = Anchor.topCenter;
    boxs.position = Vector2(game.size.x / 2, 100 + (game.size.x / 3 - 80));
    boxs.size = Vector2(game.size.x, 400);
    add(boxs);

    TextComponent start = TextComponent(
        text: "Start", textRenderer: textPaint_large, anchor: Anchor.center);
    start.anchor = Anchor.topCenter;
    start.position = Vector2(game.size.x / 2, 100 + game.size.x / 3 - 80);

    add(start);
    add(player1_opt);
    add(player2_opt);
    add(player3_opt);
    add(player4_opt);

    gameRef.players[0].is_AI = false;
  }
}

class RoundedButton extends PositionComponent with TapCallbacks {
  int? player_id;
  EileMitWeileGame? mygame;

  RoundedButton({
    required this.text,
    required this.action,
    required Color color,
    required Color borderColor,
    required EileMitWeileGame game,
    required int id,
    super.anchor = Anchor.topCenter,
  }) : _textDrawable = TextPaint(
          style: const TextStyle(
            fontSize: 50,
            color: Color(0xFF000000),
            fontWeight: FontWeight.w800,
            fontFamily: 'Komika',
          ),
        ).toTextPainter(text) {
    size = Vector2(game.size.x / 3, (game.size.x / 3 - 80) / 3);
    player_id = id;
    mygame = game;

    _textOffset = Offset(
      (size.x - _textDrawable.width) / 2,
      (size.y - _textDrawable.height) / 2,
    );

    _rrect = RRect.fromLTRBR(0, 0, size.x, size.y, Radius.circular(size.y / 9));

    _bgPaint = Paint()..color = color;

    _borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = borderColor;
  }

  String text;

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

    if (mygame!.players[this.player_id!].is_AI) {
      mygame!.players[player_id!].is_AI = false;
      if (player_id == 0) {
        player1_opt.text = "Human";
      }
      if (player_id == 1) {
        player2_opt.text = "Human";
      }
      if (player_id == 2) {
        player3_opt.text = "Human";
      }
      if (player_id == 3) {
        player4_opt.text = "Human";
      }
    } else {
      mygame!.players[player_id!].is_AI = true;
      if (player_id == 0) {
        player1_opt.text = "KI";
      }
      if (player_id == 1) {
        player2_opt.text = "KI";
      }
      if (player_id == 2) {
        player3_opt.text = "KI";
      }
      if (player_id == 3) {
        player4_opt.text = "KI";
      }
    }
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    scale = Vector2.all(1.0);
  }
}

class BoxStart extends PositionComponent
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.topCenter;
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.router.pushNamed('game');
  }
}

class BoxAIHuman extends PositionComponent
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  int player_id = 0;
  @override
  FutureOr<void> onLoad() {
    size = Vector2(400, 200);
    anchor = Anchor.center;

    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (gameRef.players[player_id].is_AI) {
      gameRef.players[player_id].is_AI = false;
    } else {
      gameRef.players[player_id].is_AI = true;
    }
  }
}
