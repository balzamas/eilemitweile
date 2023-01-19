import 'package:EileMitWeile/components/tokens.dart';
import 'package:EileMitWeile/eilemitweile_game.dart';
import 'package:flame/effects.dart';

void Move(EilemitweileGame game, Token token) {
      if (token.field!.number == 0)
      {
        token.field!.removeToken(token);
        for(var i = token.player.start_field + 1; i < token.player.start_field + game.last_throw.last_throw; i++)
        {
          if (game.fields[i].tokens.length > 0)
          {
            game.fields[i].sendHomeTokens(token.player, game.fields[0]);
          }
        }
        token.field = game.fields[token.player.start_field + game.last_throw.last_throw];
        token.add(

            MoveEffect.to(

              token.field!.addToken(token),

              EffectController(duration: 0.5),

            ),

          );
        token.last_round_moved = game.round;
        //token.position = token.field!.addToken(token);
        game.NextPlayer();

      }
      else
      { 
        token.field!.removeToken(token);

        int start_field = token.field!.number;
        int end_field = 0;

        if (start_field <= token.player.heaven_start && start_field + game.last_throw.last_throw > token.player.heaven_start)
        {
          int steps_in_heaven = game.last_throw.last_throw - (token.player.heaven_start - start_field);
          sendHome(start_field, token.player.heaven_start, game, token);
          end_field = 68 + steps_in_heaven;

        }
        else if (start_field < 69 && (start_field + game.last_throw.last_throw > 68))
        {
          end_field = start_field + game.last_throw.last_throw - 68;

          sendHome(start_field, 68, game, token);
          sendHome(0, end_field, game, token);

        }
        else
        { 
          end_field = start_field + game.last_throw.last_throw;
          sendHome(start_field, end_field, game, token);

        }
        token.field = game.fields[end_field];
        token.add(

            MoveEffect.to(

              token.field!.addToken(token),

              EffectController(duration: 0.5),

            ),

          );
        token.last_round_moved = game.round;
        game.NextPlayer();
      }
  }

  void sendHome(start_field, end_field, EilemitweileGame game, Token token)
  {
    for(var i = start_field + 1; i < end_field; i++)
    {
      if (game.fields[i].tokens.length > 0)
      {
        game.fields[i].sendHomeTokens(token.player, game.fields[0]);
      }
    }
  }