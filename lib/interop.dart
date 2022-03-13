@JS()
library main;

import 'package:js/js.dart';
import 'package:puzzlehack/models/models.dart';

@JS()
class Interop {
  external static void ready(String channelId);
  external static void join(String channelId, JsPlayer player);
  external static void setGameState(String state);
  external static void updatePlayer(JsPlayer player);
  external static void registerInput(String playerId, int input);
  external static set onPlayerChange(void Function(JsPlayer player) f);
  external static set onGameStateChange(void Function(String state) f);
  external static set onGamepadInput(
      void Function(String playerId, int input) f);
}
