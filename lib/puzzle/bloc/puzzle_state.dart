part of 'puzzle_bloc.dart';

enum Status { lobby, playing }

class PuzzleState extends Equatable {
  const PuzzleState({
    this.status = Status.playing,
    this.players = const [],
  });

  final Status status;
  final List<Player> players;

  int get numberOfPlayers => players.length;

  PuzzleState copyWith({
    Status? status,
    List<Player>? players,
  }) {
    return PuzzleState(
      status: status ?? this.status,
      players: players ?? this.players,
    );
  }

  @override
  List<Object> get props => [
        status,
        players,
      ];
}
