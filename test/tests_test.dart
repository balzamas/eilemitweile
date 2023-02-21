import 'package:EileMitWeile/components/gamelogic.dart';
import 'package:EileMitWeile/components/player.dart';
import 'package:EileMitWeile/eilemitweile_game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

final emwGameTester = FlameTester(EileMitWeileGame.new);

void main() {
  group('set up tests', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    emwGameTester.test('players created', (game) async {
      expect(game.players.length, 4);
    });

    emwGameTester.test('tokens created', (game) async {
      int total_tokens = 0;
      for (Player player in game.players) {
        total_tokens += player.tokens.length;
      }
      expect(total_tokens, 16);
    });

    emwGameTester.test('fields created', (game) async {
      expect(game.fields.length, 77);
    });
  });

  group('bench tests', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    //[blue, green, red] on the bench, can red move?
    emwGameTester.test('Move from unblocked bench', (game) async {
      game.players[1].tokens[0].field = game.fields[22];
      game.fields[22].tokens.add(game.players[1].tokens[0]);

      game.players[2].tokens[0].field = game.fields[22];
      game.fields[22].tokens.add(game.players[2].tokens[0]);

      game.players[0].tokens[0].field = game.fields[22];
      game.fields[22].tokens.add(game.players[0].tokens[0]);

      bool can_move = CheckIfTokenCanMove(game, game.players[0].tokens[0], 5);

      expect(can_move, true);
    });

    //[blue, blue, green] on the bench on field 68, can red move onto the bench?

    emwGameTester.test('Move on bench on field 68', (game) async {
      game.players[1].tokens[0].field = game.fields[68];
      game.fields[68].tokens.add(game.players[1].tokens[0]);

      game.players[1].tokens[1].field = game.fields[68];
      game.fields[68].tokens.add(game.players[1].tokens[1]);

      game.players[2].tokens[0].field = game.fields[68];
      game.fields[68].tokens.add(game.players[2].tokens[0]);

      game.players[0].tokens[0].field = game.fields[64];
      game.fields[64].tokens.add(game.players[0].tokens[0]);

      bool can_move = CheckIfTokenCanMove(game, game.players[0].tokens[0], 4);

      expect(can_move, true);
    });

    //[blue, blue, green] on the bench on field 68, is red blocked from going to heaven?

    emwGameTester.test('Red blocked from ladder', (game) async {
      game.players[1].tokens[0].field = game.fields[68];
      game.fields[68].tokens.add(game.players[1].tokens[0]);

      game.players[1].tokens[1].field = game.fields[68];
      game.fields[68].tokens.add(game.players[1].tokens[1]);

      game.players[2].tokens[0].field = game.fields[68];
      game.fields[68].tokens.add(game.players[2].tokens[0]);

      game.players[0].tokens[0].field = game.fields[64];
      game.fields[64].tokens.add(game.players[0].tokens[0]);

      bool can_move = CheckIfTokenCanMove(game, game.players[0].tokens[0], 5);

      expect(!can_move, true);
    });

    //[blue, blue, green] on the bench on field 68, is red blocked from going to heaven?

    emwGameTester.test('Pink blocked from cross 68 bench', (game) async {
      game.players[1].tokens[0].field = game.fields[68];
      game.fields[68].tokens.add(game.players[1].tokens[0]);

      game.players[1].tokens[1].field = game.fields[68];
      game.fields[68].tokens.add(game.players[1].tokens[1]);

      game.players[2].tokens[0].field = game.fields[68];
      game.fields[68].tokens.add(game.players[2].tokens[0]);

      game.players[3].tokens[0].field = game.fields[64];
      game.fields[64].tokens.add(game.players[3].tokens[0]);

      bool can_move = CheckIfTokenCanMove(game, game.players[3].tokens[0], 5);

      expect(!can_move, true);
    });

    emwGameTester.test('Pink blocked from cross 5 bench', (game) async {
      game.players[1].tokens[0].field = game.fields[5];
      game.fields[5].tokens.add(game.players[1].tokens[0]);

      game.players[1].tokens[1].field = game.fields[5];
      game.fields[5].tokens.add(game.players[1].tokens[1]);

      game.players[2].tokens[0].field = game.fields[5];
      game.fields[5].tokens.add(game.players[2].tokens[0]);

      game.players[3].tokens[0].field = game.fields[64];
      game.fields[64].tokens.add(game.players[3].tokens[0]);

      bool can_move = CheckIfTokenCanMove(game, game.players[3].tokens[0], 12);

      expect(!can_move, true);
    });

    emwGameTester.test('Move on ', (game) async {
      game.players[1].tokens[0].field = game.fields[22];
      game.fields[22].tokens.add(game.players[1].tokens[0]);

      game.players[0].tokens[0].field = game.fields[25];
      game.fields[22].tokens.add(game.players[0].tokens[0]);

      game.thrown_dices = [3];

      Move(game, game.players[1].tokens[0], game.thrown_dices[0]);

      expect(
          (game.players[1].tokens[0].field == game.fields[25] &&
              game.players[0].tokens[0].field == game.fields[25]),
          true);
    });

    //[blue, blue, green] on the bench on field 68, is red blocked from going to heaven?

    emwGameTester.test('12 from bench 68', (game) async {
      game.players[1].tokens[0].field = game.fields[68];
      game.fields[68].tokens.add(game.players[1].tokens[0]);

      game.players[1].tokens[1].field = game.fields[68];
      game.fields[68].tokens.add(game.players[1].tokens[1]);

      game.players[2].tokens[0].field = game.fields[68];
      game.fields[68].tokens.add(game.players[2].tokens[0]);

      bool can_move = CheckIfTokenCanMove(game, game.players[1].tokens[0], 12);

      expect(can_move, true);
    });

    emwGameTester.test('KI checks', (game) async {
      game.players[3].tokens[0].field = game.fields[68];
      game.fields[68].tokens.add(game.players[3].tokens[0]);

      game.players[3].tokens[1].field = game.fields[0];
      game.fields[0].tokens.add(game.players[3].tokens[1]);

      game.players[3].tokens[2].field = game.fields[0];
      game.fields[0].tokens.add(game.players[3].tokens[2]);

      game.players[3].tokens[3].field = game.fields[0];
      game.fields[0].tokens.add(game.players[3].tokens[3]);

      game.current_player = game.players[3];

      game.thrown_dices.add(12);
      game.thrown_dices.add(5);
      int dices = game.thrown_dices.length;

      for (var i = 0; i < dices; i++) {
        if (CheckTokensToMove(game, game.thrown_dices[0])) {
          game.Move_KI(game.thrown_dices[0]);
        } else {
          game.thrown_dices.removeAt(0);
        }
      }

      expect(game.thrown_dices.length, 0);
    });

    emwGameTester.test('blocked fields check red 12', (game) async {
      game.players[0].tokens[0].field = game.fields[65];
      game.fields[65].tokens.add(game.players[0].tokens[0]);

      bool can_blocked =
          CheckForBlockedFields(game, game.players[0].tokens[0], 12);

      expect(can_blocked, false);
    });
  });
}
