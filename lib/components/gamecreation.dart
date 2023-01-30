import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'field.dart';
import 'player.dart';
import '../eilemitweile_game.dart';
import '../enums.dart';

List<Player> CreatePlayers() {
  double console = EileMitWeileGame.console;
  double fieldWidth = EileMitWeileGame.fieldWidth;
  double fieldHeight = EileMitWeileGame.fieldHeight;
  List<Player> players = [];

  for (var i = 1; i < 5; i++) {
    Player player = Player();
    player.color = i;
    switch (i) {
      case 1:
        {
          player.name = "Red";
          player.home_x = console + 0;
          player.home_y = 0;
          player.start_field = 0;
          player.heaven_start = 68;
          player.color = 1;
        }
        break;

      case 2:
        {
          player.name = "Blue";
          player.home_x = console + 0;
          player.home_y = (8 * fieldHeight + 3 * fieldWidth);
          player.start_field = 17;
          player.heaven_start = 17;
          player.color = 2;
        }
        break;

      case 3:
        {
          player.name = "Green";
          player.home_x = console + (8 * fieldHeight + 3 * fieldWidth);
          player.home_y = (8 * fieldHeight + 3 * fieldWidth);
          player.start_field = 34;
          player.heaven_start = 34;
          player.color = 3;
        }
        break;

      case 4:
        {
          player.name = "Purple";
          player.home_x = console + (8 * fieldHeight + 3 * fieldWidth);
          player.home_y = 0;
          player.start_field = 51;
          player.heaven_start = 51;
          player.color = 4;
        }
        break;
    }
    players.add(player);
  }

  return players;
}

List<Field> CreateFields() {
  double console = EileMitWeileGame.console;
  double fieldWidth = EileMitWeileGame.fieldWidth;
  double fieldHeight = EileMitWeileGame.fieldHeight;
  List<Field> fields = [];

  Field home_field = Field(fieldst: FieldState.home);
  home_field.number = 0;
  home_field.position = Vector2(-400, -400);
  fields.add(home_field);

  for (var i = 1; i < 9; i++) {
    FieldState state = FieldState.normal;
    if (i == 5 ||
        (i == 12) ||
        i == 17 ||
        i == 22 ||
        i == 29 ||
        i == 34 ||
        i == 39 ||
        i == 46 ||
        i == 51 ||
        i == 56 ||
        i == 63 ||
        i == 68) {
      state = FieldState.bench;
    }
    Field field = Field(fieldst: state);
    field.position = Vector2((console + (8 * fieldHeight)), (i * fieldHeight));
    field.number = i;
    fields.add(field);
  }

  int pos = 8;
  for (var i = 9; i < 17; i++) {
    FieldState state = FieldState.normal;
    if (i == 5 ||
        (i == 12) ||
        i == 17 ||
        i == 22 ||
        i == 29 ||
        i == 34 ||
        i == 39 ||
        i == 46 ||
        i == 51 ||
        i == 56 ||
        i == 63 ||
        i == 68) {
      state = FieldState.bench;
    }
    Field field = Field(fieldst: state);
    field.position =
        Vector2((console + (pos * fieldHeight)), (9 * fieldHeight));
    field.angle = 1.57;
    field.isRotated = true;
    field.number = i;
    pos = pos - 1;

    fields.add(field);
  }

  Field fieldHeadBench1 = Field(fieldst: FieldState.bench);
  fieldHeadBench1.position =
      Vector2(console + fieldHeight, (9 * fieldHeight) + fieldWidth);
  fieldHeadBench1.angle = 1.57;
  fieldHeadBench1.isRotated = true;
  fieldHeadBench1.number = 17;
  fields.add(fieldHeadBench1);

  pos = 1;
  for (var i = 18; i < 26; i++) {
    FieldState state = FieldState.normal;
    if (i == 5 ||
        (i == 12) ||
        i == 17 ||
        i == 22 ||
        i == 29 ||
        i == 34 ||
        i == 39 ||
        i == 46 ||
        i == 51 ||
        i == 56 ||
        i == 63 ||
        i == 68) {
      state = FieldState.bench;
    }
    Field field = Field(fieldst: state);
    field.position = Vector2(
        (console + (pos * fieldHeight)), (9 * fieldHeight + 2 * fieldWidth));
    field.angle = 1.57;
    field.isRotated = true;
    field.number = i;
    pos = pos + 1;

    fields.add(field);
  }

  pos = 1;
  for (var i = 26; i < 34; i++) {
    FieldState state = FieldState.normal;
    if (i == 5 ||
        (i == 12) ||
        i == 17 ||
        i == 22 ||
        i == 29 ||
        i == 34 ||
        i == 39 ||
        i == 46 ||
        i == 51 ||
        i == 56 ||
        i == 63 ||
        i == 68) {
      state = FieldState.bench;
    }
    Field field = Field(fieldst: state);
    field.position = Vector2((console + (8 * fieldHeight)),
        (8 * fieldHeight + 3 * fieldWidth + pos * fieldHeight));
    field.number = i;
    pos = pos + 1;
    fields.add(field);
  }

  Field fieldHeadBench2 = Field(fieldst: FieldState.bench);
  fieldHeadBench2.position = Vector2((console + (8 * fieldHeight) + fieldWidth),
      (8 * fieldHeight + 3 * fieldWidth + 8 * fieldHeight));
  fieldHeadBench2.number = 34;
  fields.add(fieldHeadBench2);

  pos = 8;
  for (var i = 35; i < 43; i++) {
    FieldState state = FieldState.normal;
    if (i == 5 ||
        (i == 12) ||
        i == 17 ||
        i == 22 ||
        i == 29 ||
        i == 34 ||
        i == 39 ||
        i == 46 ||
        i == 51 ||
        i == 56 ||
        i == 63 ||
        i == 68) {
      state = FieldState.bench;
    }
    Field field = Field(fieldst: state);
    field.position = Vector2((console + (8 * fieldHeight) + (2 * fieldWidth)),
        (8 * fieldHeight + 3 * fieldWidth + pos * fieldHeight));
    field.number = i;
    pos = pos - 1;
    fields.add(field);
  }

  pos = 1;
  for (var i = 43; i < 51; i++) {
    FieldState state = FieldState.normal;
    if (i == 5 ||
        (i == 12) ||
        i == 17 ||
        i == 22 ||
        i == 29 ||
        i == 34 ||
        i == 39 ||
        i == 46 ||
        i == 51 ||
        i == 56 ||
        i == 63 ||
        i == 68) {
      state = FieldState.bench;
    }
    Field field = Field(fieldst: state);
    field.position = Vector2(
        (console + (8 * fieldHeight) + (3 * fieldWidth) + (pos * fieldHeight)),
        (9 * fieldHeight + 2 * fieldWidth));
    field.angle = 1.57;
    field.isRotated = true;
    field.number = i;
    pos = pos + 1;

    fields.add(field);
  }

  Field fieldHeadBench3 = Field(fieldst: FieldState.bench);
  fieldHeadBench3.position = Vector2(
      (console + (8 * fieldHeight) + (3 * fieldWidth) + (8 * fieldHeight)),
      (9 * fieldHeight + 1 * fieldWidth));
  fieldHeadBench3.number = 51;
  fieldHeadBench3.angle = 1.57;
  fieldHeadBench3.isRotated = true;
  fields.add(fieldHeadBench3);

  pos = 8;
  for (var i = 52; i < 60; i++) {
    FieldState state = FieldState.normal;
    if (i == 5 ||
        (i == 12) ||
        i == 17 ||
        i == 22 ||
        i == 29 ||
        i == 34 ||
        i == 39 ||
        i == 46 ||
        i == 51 ||
        i == 56 ||
        i == 63 ||
        i == 68) {
      state = FieldState.bench;
    }
    Field field = Field(fieldst: state);
    field.position = Vector2(
        (console + (8 * fieldHeight) + (3 * fieldWidth) + (pos * fieldHeight)),
        (9 * fieldHeight));
    field.angle = 1.57;
    field.isRotated = true;
    field.number = i;
    pos = pos - 1;

    fields.add(field);
  }

  pos = 8;
  for (var i = 60; i < 68; i++) {
    FieldState state = FieldState.normal;
    if (i == 5 ||
        (i == 12) ||
        i == 17 ||
        i == 22 ||
        i == 29 ||
        i == 34 ||
        i == 39 ||
        i == 46 ||
        i == 51 ||
        i == 56 ||
        i == 63 ||
        i == 68) {
      state = FieldState.bench;
    }
    Field field = Field(fieldst: state);
    field.position = Vector2(
        (console + (8 * fieldHeight) + (2 * fieldWidth)), (pos * fieldHeight));
    field.number = i;
    pos = pos - 1;
    fields.add(field);
  }

  Field fieldHeadBench4 = Field(fieldst: FieldState.bench);
  fieldHeadBench4.position =
      Vector2((console + (8 * fieldHeight) + fieldWidth), fieldHeight);
  fieldHeadBench4.number = 68;
  fields.add(fieldHeadBench4);

  for (var i = 69; i < 76; i++) {
    Field field = Field(fieldst: FieldState.ladder);
    field.number = i;
    field.position = Vector2(-400, -400);
    fields.add(field);
  }

  Field fieldHeaven = Field(fieldst: FieldState.heaven);
  fieldHeaven.position = Vector2(-400, -400);
  fieldHeaven.number = 76;
  fields.add(fieldHeaven);

  return fields;
}
