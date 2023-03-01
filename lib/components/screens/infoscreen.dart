import 'dart:async';

import 'package:flame/components.dart';

import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

import '../../eilemitweile_game.dart';

class InfoScreen extends Component
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {
    Vector2 scale = Vector2.all(game.size.x / gameRef.screenWidth);

    final style = TextStyle(
        color: BasicPalette.black.color, fontSize: 150, fontFamily: 'Poland');

    final style_small = TextStyle(
        color: BasicPalette.black.color,
        fontSize: 30,
        fontFamily: 'PolandFull');

    TextPaint textPaint = TextPaint(style: style);
    TextPaint textPaint_small = TextPaint(style: style_small);

    TextComponent title = TextComponent(
        text: "Eile mit Weile", textRenderer: textPaint, anchor: Anchor.center);

    title.position = Vector2(game.size.x / 2, scale.y * 250);
    title.scale = scale;

    add(title);

    final yamlString = await rootBundle.loadString('pubspec.yaml');
    final parsedYaml = loadYaml(yamlString);

    TextComponent subtitle = TextComponent(
        text: '"Hâte-toi lentement", "Swiss Ludo", "Swiss Parchisi"\n' +
            "Version: " +
            parsedYaml['version'],
        textRenderer: textPaint_small,
        anchor: Anchor.center);

    subtitle.position = Vector2(game.size.x / 2, scale.y * 400);
    subtitle.scale = scale;
    add(subtitle);

    TextComponent help = TextComponent(
        text: 'This app uses (mostly) the common Eile mit Weile rules.\n'
            'In short:\n'
            '- You need a 5 to move a token onto the field.\n'
            '- With a six you can move 12 fields and you can roll the dice again.\n'
            '- Three six in a row -> all tokens go gome.\n'
            '- Two token on a bench block the field for others passing through.\n'
            '- Tokens who where on the bench before the block can still move.\n'
            '- Others can always move up onto the bench.\n\n'
            'Contact: d.berger@dontsniff.co.uk\n'
            'GitHub: https://github.com/balzamas/eilemitweile\n'
            'Thanks to the Eile-mit-Weile-WM-OK, Madlaina and the Flame team.',
        textRenderer: textPaint_small,
        size: Vector2(game.size.x - 100, game.size.y),
        anchor: Anchor.topCenter);

    help.position = Vector2(game.size.x / 2, scale.y * 500);
    help.scale = scale;

    add(help);

    BoxInfo boxv = BoxInfo();

    add(boxv);
  }
}

class BoxInfo extends PositionComponent
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  FutureOr<void> onLoad() {
    position.setValues(0, 50);
    size = Vector2(2000, 1850);
    anchor = Anchor.topLeft;

    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.router.pop();
  }
}
