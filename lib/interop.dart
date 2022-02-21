@JS()
library main;

import 'package:js/js.dart';
import 'package:puzzlehack/player.dart';

@JS()
class Interop {
  external static void ready(String channelId, Player player);
  external static void join(Player player);
  external static void move(String playerId, String direction);
  external static set onPlayerChange(void Function(Player player) f);
  external static set onMove(
      void Function(String playerId, String direction) f);
}
