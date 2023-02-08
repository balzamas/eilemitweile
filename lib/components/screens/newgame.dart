import 'package:EileMitWeile/components/box_ai_human.dart';
import 'package:EileMitWeile/components/box_start.dart';
import 'package:EileMitWeile/components/box_victory.dart';
import 'package:EileMitWeile/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';

import '../../eilemitweile_game.dart';
import '../gamecreation.dart';
import '../token.dart';

final style_small = TextStyle(
    color: BasicPalette.black.color, fontSize: 30, fontFamily: 'Komika');

TextPaint textPaint_small = TextPaint(style: style_small);

TextComponent player1_opt = TextComponent(
    text: "Human", textRenderer: textPaint_small, anchor: Anchor.center);

TextComponent player2_opt = TextComponent(
    text: "KI", textRenderer: textPaint_small, anchor: Anchor.center);

TextComponent player3_opt = TextComponent(
    text: "KI", textRenderer: textPaint_small, anchor: Anchor.center);

TextComponent player4_opt = TextComponent(
    text: "KI", textRenderer: textPaint_small, anchor: Anchor.center);

class NewGameScreen extends Component
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {
    gameRef.players = CreatePlayers();

    Vector2 scale = Vector2(
        game.size.x / gameRef.screenWidth, game.size.x / gameRef.screenWidth);

    final style_large = TextStyle(
        color: BasicPalette.black.color, fontSize: 90, fontFamily: 'Komika');

    TextPaint textPaint_large = TextPaint(style: style_large);

    TextComponent title = TextComponent(
        text: "New game", textRenderer: textPaint_large, anchor: Anchor.center);
    title.position = Vector2(game.size.x / 2, scale.x * 125);
    title.scale = scale;

    add(title);

    Player player1 = Player();
    player1.color = 1;

    Token token_p1 = Token(player1);
    token_p1.position = Vector2(game.size.x / 7, scale.x * 300);
    token_p1.token_number = 0;

    Player player2 = Player();
    player2.color = 2;

    Token token_p2 = Token(player2);
    token_p2.position = Vector2(5 * (game.size.x / 7), scale.x * 300);
    token_p2.token_number = 0;

    Player player3 = Player();
    player3.color = 3;

    Token token_p3 = Token(player3);
    token_p3.position = Vector2(game.size.x / 7, scale.x * 500);
    token_p3.token_number = 0;

    Player player4 = Player();
    player4.color = 4;

    Token token_p4 = Token(player4);
    token_p4.position = Vector2(5 * (game.size.x / 7), scale.x * 500);
    token_p4.token_number = 0;
    token_p1.anchor = Anchor.center;

    add(token_p1);
    add(token_p2);
    add(token_p3);
    add(token_p4);

    player1_opt.position =
        Vector2(game.size.x / 7 + (scale.x * 150), scale.x * 325);
    player1_opt.scale = scale;

    player2_opt.position =
        Vector2(5 * (game.size.x / 7) + (scale.x * 150), scale.x * 325);
    player2_opt.scale = scale;

    player3_opt.position =
        Vector2(game.size.x / 7 + (scale.x * 150), scale.x * 525);
    player3_opt.scale = scale;

    player4_opt.position =
        Vector2(5 * (game.size.x / 7) + (scale.x * 150), scale.x * 525);
    player4_opt.scale = scale;

    add(player1_opt);
    add(player2_opt);
    add(player3_opt);
    add(player4_opt);

    BoxStart boxs = BoxStart();

    BoxAIHuman box_red = BoxAIHuman();
    box_red.position =
        Vector2(game.size.x / 7 + (scale.x * 150), scale.x * 325);
    box_red.player_id = 0;
    box_red.size = Vector2(scale.x * 400, scale.x * 200);

    BoxAIHuman box_blue = BoxAIHuman();
    box_blue.position =
        Vector2(5 * (game.size.x / 7) + (scale.x * 150), scale.x * 325);
    ;
    box_blue.player_id = 1;
    box_blue.size = Vector2(scale.x * 400, scale.x * 200);

    BoxAIHuman box_green = BoxAIHuman();
    box_green.position =
        Vector2(game.size.x / 7 + (scale.x * 150), scale.x * 525);
    ;
    box_green.player_id = 2;
    box_green.size = Vector2(scale.x * 400, scale.x * 200);

    BoxAIHuman box_purple = BoxAIHuman();
    box_purple.position =
        Vector2(5 * (game.size.x / 7) + (scale.x * 150), scale.x * 525);
    ;
    box_purple.size = Vector2(scale.x * 400, scale.x * 200);

    box_purple.player_id = 3;

    boxs.position = Vector2(game.size.x / 2, scale.x * 780);
    boxs.size = Vector2(2000, scale.x * 200);
    add(boxs);

    add(box_red);
    add(box_blue);
    add(box_green);
    add(box_purple);

    TextComponent start = TextComponent(
        text: "Start", textRenderer: textPaint_large, anchor: Anchor.center);
    start.position = Vector2(game.size.x / 2, scale.x * 770);
    start.scale = scale;

    add(start);

    gameRef.players[0].is_AI = false;
  }
}

class BoxAIHuman extends PositionComponent
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  int player_id = 0;
  @override
  Future<void>? onLoad() {
    anchor = Anchor.center;

    return super.onLoad();
  }

  @override
  bool get debugMode => false;

  @override
  late double opacity;

  @override
  void onTapUp(TapUpEvent event) {
    if (gameRef.players[player_id].is_AI) {
      gameRef.players[player_id].is_AI = false;
      if (player_id == 0) {
        player1_opt.text = "Human";
      }
      if (player_id == 1) {
        player2_opt.text = "Human";
      }
      if (player_id == 2) {
        player3_opt.text = "Human";
      }
      if (player_id == 3) {
        player4_opt.text = "Human";
      }
    } else {
      gameRef.players[player_id].is_AI = true;
      if (player_id == 0) {
        player1_opt.text = "KI";
      }
      if (player_id == 1) {
        player2_opt.text = "KI";
      }
      if (player_id == 2) {
        player3_opt.text = "KI";
      }
      if (player_id == 3) {
        player4_opt.text = "KI";
      }
    }
  }
}
