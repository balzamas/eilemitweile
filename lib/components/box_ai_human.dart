import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';

import '../eilemitweile_game.dart';

class BoxAIHuman extends PositionComponent
    with TapCallbacks, OpacityProvider, HasGameRef<EileMitWeileGame> {
  int player_id = 0;
  @override
  Future<void>? onLoad() {
    size = Vector2(400, 200);
    anchor = Anchor.center;

    return super.onLoad();
  }

  @override
  bool get debugMode => true;

  @override
  late double opacity;

  @override
  void onTapUp(TapUpEvent event) {
    if (gameRef.players[player_id].is_AI) {
      gameRef.players[player_id].is_AI = false;
    } else {
      gameRef.players[player_id].is_AI = true;
    }
  }
}
