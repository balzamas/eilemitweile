import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';

import '../eilemitweile_game.dart';

class BoxStart extends PositionComponent
    with TapCallbacks, OpacityProvider, HasGameRef<EileMitWeileGame> {
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
    gameRef.router.pushNamed('game');
  }
}
