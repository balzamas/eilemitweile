import 'package:EileMitWeile/eilemitweile_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScoreText extends TextComponent with HasGameRef<EilemitweileGame> {
  late int last_throw;

  ScoreText.playerScore({
    this.last_throw = 0,
  })  : _textPaint = TextPaint(
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 248, color: Colors.black)),
        super(
          anchor: Anchor.center,
        );

  late final TextPaint _textPaint;

  @override
  Future<void>? onLoad() {
    last_throw = 0;
    final textOffset =
        (_textPaint.textDirection == TextDirection.ltr ? -1 : 1) * 50;
    position.setValues(150, 500);
    text = last_throw.toString();

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    _textPaint.render(canvas, '$last_throw', Vector2.zero());
  }
}
