import 'package:flame/components.dart';

import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

import '../../eilemitweile_game.dart';
import '../box_victory.dart';

class InfoScreen extends Component
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {
    Vector2 scale = Vector2.all(game.size.x / gameRef.screenWidth);

    final style = TextStyle(
        color: BasicPalette.black.color, fontSize: 150, fontFamily: 'Komika');

    final style_small = TextStyle(
        color: BasicPalette.black.color, fontSize: 30, fontFamily: 'Komika');

    TextPaint textPaint = TextPaint(style: style);
    TextPaint textPaint_small = TextPaint(style: style_small);

    TextComponent title = TextComponent(
        text: "Eile mit Weile", textRenderer: textPaint, anchor: Anchor.center);

    title.position = Vector2(game.size.x / 2, scale.y * 100);
    title.scale = scale;

    add(title);

    final yamlString = await rootBundle.loadString('pubspec.yaml');
    final parsedYaml = loadYaml(yamlString);

    TextComponent subtitle = TextComponent(
        text: '"Hâte-toi lentement", "Swiss Ludo", "Swiss Parchisi"\n' +
            "Version: " +
            parsedYaml['version'],
        textRenderer: textPaint_small,
        anchor: Anchor.center);

    subtitle.position = Vector2(game.size.x / 2, scale.y * 250);
    subtitle.scale = scale;
    add(subtitle);

    TextComponent help = TextComponent(
        text: 'This app uses (mostly) the common Eile mit Weile rules.\n'
            'In short:\n'
            '- You need a 5 to move a token onto the field.\n'
            '- With a six you can move 12 fields and you can roll the dice again.\n'
            '- Three six in a row -> all tokens go gome.\n'
            '- Two token on a bench block the field for others passing through.\n'
            '- Tokens who where on the bench before the block can still move.\n'
            '- Others can always move up onto the bench.\n\n'
            'Contact: d.berger@dontsniff.co.uk\n'
            'GitHub: https://github.com/balzamas/eilemitweile\n'
            'Thanks to the Eile-mit-Weile-WM-OK, Madlaina and the Flame team.',
        textRenderer: textPaint_small,
        size: Vector2(game.size.x - 100, game.size.y),
        anchor: Anchor.topCenter);

    help.position = Vector2(game.size.x / 2, scale.y * 350);
    help.scale = scale;

    add(help);

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
