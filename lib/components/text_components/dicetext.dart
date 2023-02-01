import 'package:flame/components.dart';
import 'package:flutter/material.dart';

//With TextBoxComponent this crashes on Android Mobile Chrome
class DiceText extends TextComponent {
  DiceText(String text)
      : super(
          text: text,
          //align: Anchor.center, //TextBox only
          size: Vector2(500, 200),
          textRenderer: TextPaint(
              textDirection: TextDirection.ltr,
              style: TextStyle(
                  fontSize: 110, color: Colors.black, fontFamily: 'Komika')),
          //boxConfig: TextBoxConfig(timePerChar: 0.05), //TextBox only
        );

  @override
  bool get debugMode => false;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
