import 'dart:ui';

import 'package:EileMitWeile/components/movement.dart';
import 'package:EileMitWeile/components/paeng.dart';
import 'package:EileMitWeile/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';

import '../eilemitweile_game.dart';
import 'field.dart';

class Box extends PositionComponent
    with TapCallbacks, OpacityProvider, HasGameRef<EilemitweileGame> {
  bool can_move = false;
  int last_round_moved = 0;
  int cur_tile = 0;
  int token_number = 0;
  late Player player;
  Field? field;
  int bodycount = 0;
  Token(Player player) {
    this.player = player;
  }

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
}
