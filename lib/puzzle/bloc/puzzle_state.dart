part of 'puzzle_bloc.dart';

enum Status { lobby, playing, complete }

class PuzzleState extends Equatable {
  const PuzzleState({
    this.status = Status.lobby,
    this.players = const [],
    this.puzzles = const {},
    this.playersReady = const {},
    required this.playerThemes,
    required this.secondsToBegin,
    this.isCountdownRunning = false,
    this.winner,
  });

  final Status status;
  final List<Player> players;
  final Map<String, Puzzle> puzzles;
  final Map<String, bool> playersReady;
  final List<PlayerTheme> playerThemes;
  final int secondsToBegin;
  final bool isCountdownRunning;
  final int? winner;

  int get numberOfPlayers => players.length;
  Player? get champion => status == Status.complete ? players[winner!] : null;

  PlayerTheme themeForPlayer(int playerIndex) =>
      playerThemes[players[playerIndex].theme];

  PuzzleState copyWith({
    Status? status,
    List<Player>? players,
    Map<String, Puzzle>? puzzles,
    Map<String, bool>? playersReady,
    List<PlayerTheme>? playerThemes,
    int? secondsToBegin,
    bool? isCountdownRunning,
    int? winner,
  }) {
    return PuzzleState(
      status: status ?? this.status,
      players: players ?? this.players,
      puzzles: puzzles ?? this.puzzles,
      playersReady: playersReady ?? this.playersReady,
      playerThemes: playerThemes ?? this.playerThemes,
      secondsToBegin: secondsToBegin ?? this.secondsToBegin,
      isCountdownRunning: isCountdownRunning ?? this.isCountdownRunning,
      winner: winner ?? this.winner,
    );
  }

  @override
  List<Object> get props => [
        status,
        players,
        puzzles,
        playersReady,
        isCountdownRunning,
        secondsToBegin,
      ];
}
