import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DiceText extends TextBoxComponent {
  String _text = "";
  DiceText(String text)
      : super(
          text: text,
          align: Anchor.center,
          size: Vector2(500, 200),
          textRenderer: TextPaint(
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  fontSize: 130, color: Colors.black, fontFamily: 'Komika')),
          boxConfig: TextBoxConfig(timePerChar: 0.05),
        );

  @override
  bool get debugMode => false;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
