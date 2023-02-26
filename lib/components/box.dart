import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import '../eilemitweile_game.dart';

class Box extends PositionComponent
    with TapCallbacks, HasGameRef<EileMitWeileGame> {
  @override
  FutureOr<void> onLoad() {
    position.setValues(0, 50);
    size = Vector2(2000, 1850);
    anchor = Anchor.topLeft;

    return super.onLoad();
  }

  @override
  bool get debugMode => false;
}
