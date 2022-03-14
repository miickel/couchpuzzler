part of 'puzzle_bloc.dart';

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent();

  @override
  List<Object> get props => [];
}

class PlayerAdded extends PuzzleEvent {
  const PlayerAdded(this.player);
  final Player player;

  @override
  List<Object> get props => [player];
}

class PlayerRemoved extends PuzzleEvent {
  const PlayerRemoved(this.player);
  final Player player;

  @override
  List<Object> get props => [player];
}

class GameStarted extends PuzzleEvent {}

class CountdownTicked extends PuzzleEvent {}

class GamepadInputRegistered extends PuzzleEvent {
  final String playerId;
  final int input;

  const GamepadInputRegistered(this.playerId, this.input);

  @override
  List<Object> get props => [playerId, input];
}
