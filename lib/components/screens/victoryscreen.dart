import 'package:EileMitWeile/components/box_victory.dart';
import 'package:EileMitWeile/components/sprites/victory.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';

import '../../eilemitweile_game.dart';
import '../token.dart';

class VictoryScreen extends Component
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {
    Victory victory = Victory();
    victory.position =
        Vector2(game.size.x / 2, game.size.x / gameRef.screenWidth * 350);
    victory.scale = Vector2(
        game.size.x / gameRef.screenWidth, game.size.x / gameRef.screenWidth);
    add(victory);

    final style = TextStyle(
        color: BasicPalette.black.color, fontSize: 100, fontFamily: 'Komika');

    final style_small = TextStyle(
        color: BasicPalette.black.color, fontSize: 30, fontFamily: 'Komika');

    TextPaint textPaint = TextPaint(style: style);
    TextPaint textPaint_small = TextPaint(style: style_small);

    TextComponent winner = TextComponent(
        text: gameRef.current_player!.name,
        textRenderer: textPaint,
        anchor: Anchor.center);

    winner.position =
        Vector2(game.size.x / 2, game.size.x / gameRef.screenWidth * 750);
    winner.scale = Vector2(
        game.size.x / gameRef.screenWidth, game.size.x / gameRef.screenWidth);

    add(winner);

    TextComponent stats = TextComponent(
        text: "Turns: " + game.round.toString(),
        textRenderer: textPaint_small,
        anchor: Anchor.center);

    stats.position =
        Vector2(game.size.x / 2, game.size.x / gameRef.screenWidth * 900);
    stats.scale = Vector2(
        game.size.x / gameRef.screenWidth, game.size.x / gameRef.screenWidth);

    add(stats);

    Token topkiller_1;
    topkiller_1 = game.players[0].tokens[0];
    for (Token token in game.players[0].tokens) {
      if (token.bodycount > topkiller_1.bodycount) {
        topkiller_1 = token;
      }
    }

    Token topkiller_1_x = Token(game.players[0]);
    topkiller_1_x.token_number = topkiller_1.token_number;

    topkiller_1_x.position = Vector2(
        game.size.x / 2 - (game.size.x / gameRef.screenWidth * 50),
        game.size.x / gameRef.screenWidth * 925);
    topkiller_1_x.scale = Vector2(
        game.size.x / gameRef.screenWidth, game.size.x / gameRef.screenWidth);
    topkiller_1_x.anchor = Anchor.center;
    add(topkiller_1_x);

    TextComponent kills = TextComponent(
        text: "Top killer with " + topkiller_1.bodycount.toString() + " kills.",
        textRenderer: textPaint_small,
        anchor: Anchor.center);

    kills.position =
        Vector2(game.size.x / 2, game.size.x / gameRef.screenWidth * 1000);
    kills.scale = Vector2(
        game.size.x / gameRef.screenWidth, game.size.x / gameRef.screenWidth);

    add(kills);

    BoxVictory boxv = BoxVictory();

    add(boxv);
  }
}
