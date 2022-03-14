import 'package:equatable/equatable.dart';
import 'package:puzzlehack/models/models.dart';

class Player extends Equatable {
  final String id;
  final int theme;

  const Player({
    required this.id,
    this.theme = 0,
  });

  static fromJsPlayer(JsPlayer player) {
    return Player(
      id: player.id,
      theme: player.theme,
    );
  }

  Player copyWith({
    int? theme,
  }) {
    return Player(
      id: id,
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object?> get props => [id, theme];
}
