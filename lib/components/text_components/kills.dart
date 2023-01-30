import 'package:EileMitWeile/eilemitweile_game.dart';
import 'package:flame/components.dart';

import 'package:flutter/material.dart';

class KillInfo extends TextComponent with HasGameRef<EileMitWeileGame> {
  late String text_content;

  KillInfo.killInfo({
    this.text_content = "",
  }) : _textPaint = TextPaint(
            textDirection: TextDirection.rtl,
            style: TextStyle(
                fontSize: 50, color: Colors.black, fontFamily: 'Komika'));

  late final TextPaint _textPaint;

  @override
  Future<void>? onLoad() {
    text_content = "Kills\nRed: 0\nBlue: 0\nGreen: 0\nPurple: 0";
    anchor = Anchor.center;
    position.setValues(260, 1300);
    text = text_content;

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    _textPaint.render(canvas, text_content, Vector2.zero(), anchor: anchor);
  }
}
