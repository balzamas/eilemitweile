import 'dart:async';

import 'package:EileMitWeile/eilemitweile_game.dart';
import 'package:flame/components.dart';

import 'package:flutter/material.dart';

class StateButton extends TextComponent with HasGameRef<EileMitWeileGame> {
  late String text_content;
  late bool is_right = false;

  @override
  bool get debugMode => false;

  StateButton.stateInfo({
    this.text_content = "",
  }) : _textPaint = TextPaint(
            textDirection: TextDirection.ltr,
            style: TextStyle(
                fontSize: 90, color: Colors.black, fontFamily: 'Poland'));

  late final TextPaint _textPaint;

  @override
  FutureOr<void> onLoad() {
    text_content = "🎲 Roll dice 🎲";
    anchor = Anchor.center;
    text = text_content;
    if (is_right) {
      angle = 4.71;
    } else {
      angle = 1.57;
    }

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    _textPaint.render(canvas, text_content, Vector2.zero(), anchor: anchor);
  }
}
