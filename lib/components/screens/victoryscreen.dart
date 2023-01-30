import 'package:EileMitWeile/components/token.dart';
import 'package:flame/components.dart';

import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';

import 'package:flutter/rendering.dart';

import '../../eilemitweile_game.dart';
import '../box_victory.dart';
import '../sprites/victory.dart';

class VictoryScreen extends Component
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    Vector2 scale = Vector2.all(game.size.x / gameRef.screenWidth);

    Victory victory = Victory();
    victory.position = Vector2(game.size.x / 2, scale.y * 200);
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

    winner.position = Vector2(game.size.x / 2, scale.y * 500);
    winner.scale = scale;

    add(winner);

    TextComponent stats = TextComponent(
        text: "Turns: " + game.round.toString(),
        textRenderer: textPaint_small,
        anchor: Anchor.center);

    stats.position = Vector2(game.size.x / 2, scale.y * 700);
    stats.scale = scale;

    add(stats);

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
        Vector2(game.size.x / 2 - (scale.x * 25), scale.y * 800);
    topkiller_1_x.scale = scale;
    topkiller_1_x.anchor = Anchor.center;
    add(topkiller_1_x);

    TextComponent kills = TextComponent(
        text: "Your top killer with " +
            topkiller_1.bodycount.toString() +
            " kills:",
        textRenderer: textPaint_small,
        anchor: Anchor.center);

    kills.position = Vector2(game.size.x / 2, scale.y * 775);
    kills.scale = scale;

    add(kills);

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
