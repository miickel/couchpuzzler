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
