import 'package:EileMitWeile/eilemitweile_game.dart';
import 'package:flame/components.dart';

class DiceTComponent extends SpriteComponent with HasGameRef<EileMitWeileGame> {
  int dice_number = 0;

  DiceTComponent({
    required Vector2 position,
    required int dice_number,
  }) : super(position: position, size: Vector2(190, 190)) {
    this.dice_number = dice_number;
  }

  @override
  Future<void> onLoad() async {
    int count = dice_number;
    if (dice_number == 12) {
      count = 6;
    }

    Sprite the_sprite = emwSprite((count - 1) * 300, 2102, 300, 300);
    this.sprite = the_sprite;
  }
}
