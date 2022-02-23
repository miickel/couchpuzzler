part of 'lobby_bloc.dart';

abstract class LobbyState extends Equatable {
  const LobbyState(this.players);

  final Set<Player> players;

  @override
  List<Object> get props => [];
}

class LobbyWaiting extends LobbyState {
  const LobbyWaiting(Set<Player> players) : super(players);
}

class LobbyReady extends LobbyState {
  const LobbyReady(Set<Player> players) : super(players);
}

class LobbyPlaying extends LobbyState {
  const LobbyPlaying(Set<Player> players) : super(players);
}
