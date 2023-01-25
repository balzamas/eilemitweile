import 'package:EileMitWeile/eilemitweile_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScoreText extends TextComponent with HasGameRef<EilemitweileGame> {
  late String text_content;

  ScoreText.playerScore({
    this.text_content = "",
  }) : _textPaint = TextPaint(
            textDirection: TextDirection.rtl,
            style: TextStyle(
                fontSize: 80, color: Colors.black, fontFamily: 'Komika'));

  late final TextPaint _textPaint;

  @override
  Future<void>? onLoad() {
    text_content = "";
    position.setValues(190, 500);
    anchor = Anchor.center;

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    _textPaint.render(canvas, text_content, Vector2.zero());
  }
}
