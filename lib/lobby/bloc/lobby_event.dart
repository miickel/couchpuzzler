part of 'lobby_bloc.dart';

abstract class LobbyEvent extends Equatable {
  const LobbyEvent();

  @override
  List<Object> get props => [];
}

class PlayerAdded extends LobbyEvent {
  const PlayerAdded(this.player);
  final Player player;

  @override
  List<Object> get props => [player];
}

class PlayerRemoved extends LobbyEvent {
  const PlayerRemoved(this.player);
  final Player player;

  @override
  List<Object> get props => [player];
}

class GameStarted extends LobbyEvent {}
