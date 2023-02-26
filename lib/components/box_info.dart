import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';

import '../eilemitweile_game.dart';

class BoxInfo extends PositionComponent
    with TapCallbacks, OpacityProvider, HasGameRef<EileMitWeileGame> {
  @override
  Future<void>? onLoad() {
    position.setValues(0, 50);
    size = Vector2(2000, 1850);
    anchor = Anchor.topLeft;

    return super.onLoad();
  }

  @override
  bool get debugMode => false;

  @override
  late double opacity;

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.router.pop();
  }
}
