import 'package:EileMitWeile/eilemitweile_game.dart';
import 'package:flame/components.dart';

import 'package:flutter/material.dart';

class InfoText extends TextComponent with HasGameRef<EilemitweileGame> {
  late String text_content;

  InfoText.playerScore({
    this.text_content = "",
  }) : _textPaint = TextPaint(
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 80, color: Colors.black));

  late final TextPaint _textPaint;

  @override
  Future<void>? onLoad() {
    text_content = "Red\n\nTurn 1";
    anchor = Anchor.center;
    position.setValues(160, 1000);
    text = text_content;

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    _textPaint.render(canvas, text_content, Vector2.zero(), anchor: anchor);
  }
}
