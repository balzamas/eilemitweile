import 'package:EileMitWeile/components/field.dart';
import 'package:EileMitWeile/components/tokens.dart';
import 'package:flame/components.dart';

class Player extends PositionComponent {
  int color = 1;
  bool is_AI = true;
  String name = "";
  double home_x = 0;
  double home_y = 0;
  int start_field = 0;
  int heaven_start = 0;
  List<Token> tokens = [];
  List<Field> ladder_fields = [];
  int bodycount = 0;
}
