import 'dart:async';

import 'package:EileMitWeile/components/token.dart';
import 'package:flame/components.dart';

import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';

import 'package:flutter/rendering.dart';

import '../../eilemitweile_game.dart';
import '../sprites/victory.dart';

class VictoryScreen extends Component
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {
    Vector2 scale = Vector2.all(game.size.x / gameRef.screenWidth);

    Victory victory = Victory();
    victory.position = Vector2(game.size.x / 2, scale.y * 250);
    victory.scale = scale / 2;
    add(victory);

    final style = TextStyle(
        color: BasicPalette.black.color, fontSize: 100, fontFamily: 'Komika');

    final style_small = TextStyle(
        color: BasicPalette.black.color, fontSize: 30, fontFamily: 'Komika');

    TextPaint textPaint = TextPaint(style: style);
    TextPaint textPaint_small = TextPaint(style: style_small);

    TextComponent winner = TextComponent(
        text: gameRef.current_player!.name,
        textRenderer: textPaint,
        anchor: Anchor.center);

    winner.position = Vector2(game.size.x / 2, scale.y * 550);
    winner.scale = scale;

    add(winner);

    TextComponent stats = TextComponent(
        text: "Turns: " + game.round.toString(),
        textRenderer: textPaint_small,
        anchor: Anchor.center);

    stats.position = Vector2(game.size.x / 2, scale.y * 700);
    stats.scale = scale;

    add(stats);

    TextComponent killstitle = TextComponent(
        text: "Topkillers",
        textRenderer: textPaint_small,
        anchor: Anchor.center);

    killstitle.position = Vector2(game.size.x / 2, scale.y * 750);
    killstitle.scale = scale;

    add(killstitle);

    Token topkiller_1;
    topkiller_1 = game.players[0].tokens[0];
    for (Token token in game.players[0].tokens) {
      if (token.bodycount > topkiller_1.bodycount) {
        topkiller_1 = token;
      }
    }

    Token topkiller_1_x = Token(game.players[0]);
    topkiller_1_x.token_number = topkiller_1.token_number;

    topkiller_1_x.position =
        Vector2(3 * (game.size.x / 9) - (scale.x * 25), scale.y * 800);
    topkiller_1_x.scale = scale;
    topkiller_1_x.anchor = Anchor.center;
    add(topkiller_1_x);

    Token topkiller_2;
    topkiller_2 = game.players[1].tokens[0];
    for (Token token in game.players[1].tokens) {
      if (token.bodycount > topkiller_2.bodycount) {
        topkiller_2 = token;
      }
    }

    Token topkiller_2_x = Token(game.players[1]);
    topkiller_2_x.token_number = topkiller_2.token_number;

    topkiller_2_x.position =
        Vector2(4 * (game.size.x / 9) - (scale.x * 25), scale.y * 800);
    topkiller_2_x.scale = scale;
    topkiller_2_x.anchor = Anchor.center;
    add(topkiller_2_x);

    Token topkiller_3;
    topkiller_3 = game.players[2].tokens[0];
    for (Token token in game.players[2].tokens) {
      if (token.bodycount > topkiller_3.bodycount) {
        topkiller_3 = token;
      }
    }

    Token topkiller_3_x = Token(game.players[2]);
    topkiller_3_x.token_number = topkiller_3.token_number;

    topkiller_3_x.position =
        Vector2(5 * (game.size.x / 9) - (scale.x * 25), scale.y * 800);
    topkiller_3_x.scale = scale;
    topkiller_3_x.anchor = Anchor.center;
    add(topkiller_3_x);

    Token topkiller_4;
    topkiller_4 = game.players[3].tokens[0];
    for (Token token in game.players[3].tokens) {
      if (token.bodycount > topkiller_4.bodycount) {
        topkiller_4 = token;
      }
    }

    Token topkiller_4_x = Token(game.players[3]);
    topkiller_4_x.token_number = topkiller_4.token_number;

    topkiller_4_x.position =
        Vector2(6 * (game.size.x / 9) - (scale.x * 25), scale.y * 800);
    topkiller_4_x.scale = scale;
    topkiller_4_x.anchor = Anchor.center;
    add(topkiller_4_x);

    TextComponent kills1 = TextComponent(
        text: topkiller_1.bodycount.toString(),
        textRenderer: textPaint_small,
        anchor: Anchor.center);

    kills1.position = Vector2(3 * (game.size.x / 9), scale.y * 900);
    kills1.scale = scale;

    TextComponent kills2 = TextComponent(
        text: topkiller_2.bodycount.toString(),
        textRenderer: textPaint_small,
        anchor: Anchor.center);

    kills2.position = Vector2(4 * (game.size.x / 9), scale.y * 900);
    kills2.scale = scale;

    TextComponent kills3 = TextComponent(
        text: topkiller_3.bodycount.toString(),
        textRenderer: textPaint_small,
        anchor: Anchor.center);

    kills3.position = Vector2(5 * (game.size.x / 9), scale.y * 900);
    kills3.scale = scale;

    TextComponent kills4 = TextComponent(
        text: topkiller_4.bodycount.toString(),
        textRenderer: textPaint_small,
        anchor: Anchor.center);

    kills4.position = Vector2(6 * (game.size.x / 9), scale.y * 900);
    kills4.scale = scale;

    add(kills1);
    add(kills2);
    add(kills3);
    add(kills4);

    BoxVictory boxv = BoxVictory();

    add(boxv);
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

class BoxVictory extends PositionComponent
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  FutureOr<void> onLoad() {
    position.setValues(0, 50);
    size = Vector2(2000, 1850);
    anchor = Anchor.topLeft;

    return super.onLoad();
  }

  @override
  bool get debugMode => false;

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.router.pop();
    gameRef.router.pushNamed('newgame');
  }
}
