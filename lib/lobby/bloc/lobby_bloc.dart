import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:puzzlehack/models/models.dart';

part 'lobby_event.dart';
part 'lobby_state.dart';

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  static final Set<Player> _players = HashSet();

  LobbyBloc() : super(LobbyWaiting(_players)) {
    on<PlayerAdded>(_onPlayerAdded);
    on<PlayerRemoved>(_onPlayerRemoved);
    on<GameStarted>(_onGameStarted);
  }

  _onPlayerAdded(PlayerAdded event, Emitter<LobbyState> emit) {
    var players = HashSet<Player>.from(state.players)..add(event.player);
    _emitReadyWaiting(emit, players);
  }

  _onPlayerRemoved(PlayerRemoved event, Emitter<LobbyState> emit) {
    var players = HashSet<Player>.from(state.players)..remove(event.player);
    _emitReadyWaiting(emit, players);
  }

  _onGameStarted(GameStarted event, Emitter<LobbyState> emit) {
    emit(LobbyPlaying(HashSet<Player>.from(state.players)));
  }

  _emitReadyWaiting(Emitter<LobbyState> emit, HashSet<Player> players) {
    if (players.length > 1) {
      emit(LobbyReady(players));
    } else {
      emit(LobbyWaiting(players));
    }
  }
}
