import 'package:flutter/material.dart';

import '../player.dart';

class PuzzleModel extends ChangeNotifier {
  final List<Player> _players = [];

  void addPlayer(Player player) {
    _players.add(player);
    notifyListeners();
  }
}
