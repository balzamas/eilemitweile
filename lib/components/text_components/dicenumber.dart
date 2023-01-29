import 'package:EileMitWeile/eilemitweile_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScoreText extends TextBoxComponent with HasGameRef<EilemitweileGame> {
  late String text_content;

  ScoreText.playerScore({
    this.text_content = "12 12 5",
  }) : _textPaint = TextPaint(
            textDirection: TextDirection.rtl,
            style: TextStyle(
                fontSize: 120, color: Colors.black, fontFamily: 'Komika'));

  late final TextPaint _textPaint;

  // @override
  // Future<void>? onLoad() {
  //   text_content = "";
  //   position.setValues(170, 460);
  //   anchor = Anchor.center;

  //   return super.onLoad();
  // }

  @override
  bool get debugMode => true;

  @override
  void render(Canvas canvas) {
    this.align = Anchor.topCenter;
    this.anchor = Anchor.center;
    this.size = Vector2(EilemitweileGame.console, 300);
    this.position = Vector2(EilemitweileGame.console / 2, 600);
    _textPaint.render(canvas, text_content, Vector2.zero());
  }
}
