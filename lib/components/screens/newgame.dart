import 'package:EileMitWeile/components/box_victory.dart';
import 'package:EileMitWeile/components/player.dart';
import 'package:EileMitWeile/components/sprites/victory.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';

import '../../eilemitweile_game.dart';
import '../token.dart';

class NewGameScreen extends Component
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {
    Vector2 scale = Vector2(
        game.size.x / gameRef.screenWidth, game.size.x / gameRef.screenWidth);

    Player player1 = Player();
    player1.color = 1;

    Token token_p1 = Token(player1);
    token_p1.position = Vector2(game.size.x / 4, 100);
    token_p1.token_number = 0;

    Player player2 = Player();
    player2.color = 2;

    Token token_p2 = Token(player2);
    token_p2.position = Vector2(3 * (game.size.x / 4), 100);
    token_p2.token_number = 0;

    Player player3 = Player();
    player3.color = 3;

    Token token_p3 = Token(player3);
    token_p3.position = Vector2(game.size.x / 4, 300);
    token_p3.token_number = 0;

    Player player4 = Player();
    player4.color = 3;

    Token token_p4 = Token(player4);
    token_p4.position = Vector2(3 * (game.size.x / 4), 300);
    token_p4.token_number = 0;
    token_p1.anchor = Anchor.center;

    add(token_p1);
    add(token_p2);
    add(token_p3);
    add(token_p4);

    final style = TextStyle(
        color: BasicPalette.black.color, fontSize: 100, fontFamily: 'Komika');

    final style_small = TextStyle(
        color: BasicPalette.black.color, fontSize: 30, fontFamily: 'Komika');

    TextPaint textPaint = TextPaint(style: style);
    TextPaint textPaint_small = TextPaint(style: style_small);

    TextComponent player1_opt = TextComponent(
        text: "Human", textRenderer: textPaint_small, anchor: Anchor.center);

    TextComponent player2_opt = TextComponent(
        text: "KI", textRenderer: textPaint_small, anchor: Anchor.center);

    TextComponent player3_opt = TextComponent(
        text: "KI", textRenderer: textPaint_small, anchor: Anchor.center);

    TextComponent player4_opt = TextComponent(
        text: "KI", textRenderer: textPaint_small, anchor: Anchor.center);

    player1_opt.position = Vector2(game.size.x / 4 + (scale.x * 150), 125);
    player1_opt.scale = scale;

    player2_opt.position =
        Vector2(3 * (game.size.x / 4) + (scale.x * 150), 125);
    player2_opt.scale = scale;

    player3_opt.position = Vector2(game.size.x / 4 + (scale.x * 150), 325);
    player3_opt.scale = scale;

    player4_opt.position =
        Vector2(3 * (game.size.x / 4) + (scale.x * 150), 325);
    player4_opt.scale = scale;

    add(player1_opt);
    add(player2_opt);
    add(player3_opt);
    add(player4_opt);

    BoxVictory boxv = BoxVictory();

    add(boxv);
  }
}
