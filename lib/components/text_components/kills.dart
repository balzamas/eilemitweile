import 'package:EileMitWeile/eilemitweile_game.dart';
import 'package:flame/components.dart';

import 'package:flutter/material.dart';

class KillInfo extends TextComponent with HasGameRef<EileMitWeileGame> {
  late String text_content;

  KillInfo.killInfo({
    this.text_content = "",
  }) : _textPaint = TextPaint(
            textDirection: TextDirection.ltr,
            style: TextStyle(
                fontSize: 50, color: Colors.black, fontFamily: 'Komika'));

  late final TextPaint _textPaint;

  @override
  Future<void>? onLoad() {
    text_content = "Turn 1 // Kills: Red 0 // Blue 0 // Green 0 // Purple 0";
    anchor = Anchor.centerLeft;
    text = text_content;

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    _textPaint.render(canvas, text_content, Vector2.zero(), anchor: anchor);
  }
}
