part of 'puzzle_bloc.dart';

enum Status { lobby, playing }

class PuzzleState extends Equatable {
  const PuzzleState(
      {this.status = Status.lobby,
      this.players = const [],
      required this.playerThemes});

  final Status status;
  final List<Player> players;
  final List<PlayerTheme> playerThemes;

  int get numberOfPlayers => players.length;

  PlayerTheme themeForPlayer(int playerIndex) =>
      playerThemes[players[playerIndex].theme];

  PuzzleState copyWith({
    Status? status,
    List<Player>? players,
    List<PlayerTheme>? playerThemes,
  }) {
    return PuzzleState(
      status: status ?? this.status,
      players: players ?? this.players,
      playerThemes: playerThemes ?? this.playerThemes,
    );
  }

  @override
  List<Object> get props => [
        status,
        players,
      ];
}
