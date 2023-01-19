import 'package:EileMitWeile/eilemitweile_game.dart';
import 'package:flame/components.dart';

import 'package:flutter/material.dart';


class InfoText extends TextComponent with HasGameRef<EilemitweileGame> {
 late String text_content;
 
 InfoText.playerScore({
 this.text_content = "",
 })  : _textPaint = TextPaint(textDirection: TextDirection.rtl, style: TextStyle(fontSize: 100, color: Colors.black)), 
 super(
         anchor: Anchor.center,
       );
 
 late final TextPaint _textPaint;
 
 @override
 Future<void>? onLoad() {
   text_content = "fffff";
 final textOffset =
       (_textPaint.textDirection == TextDirection.ltr ? -1 : 1) * 50;
   position.setValues(50,800);
   text = text_content;
 
 return super.onLoad();
 }
 
 @override
 void render(Canvas canvas) {
   _textPaint.render(canvas, text_content, Vector2.zero());
 }
}