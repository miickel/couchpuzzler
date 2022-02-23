@JS()
library main;

import 'package:js/js.dart';
import 'package:puzzlehack/models/js_player.dart';

@JS()
class Interop {
  external static void ready(String channelId);
  external static void join(JsPlayer player);
  external static void move(String playerId, String direction);
  external static set onPlayerChange(void Function(JsPlayer player) f);
  external static set onMove(
      void Function(String playerId, String direction) f);
}
