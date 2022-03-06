import 'package:equatable/equatable.dart';
import 'package:puzzlehack/models/js_player.dart';

class Player extends Equatable {
  final String id;

  const Player(this.id);

  static fromJsPlayer(JsPlayer player) {
    return Player(player.id);
  }

  @override
  List<Object?> get props => [id];
}
