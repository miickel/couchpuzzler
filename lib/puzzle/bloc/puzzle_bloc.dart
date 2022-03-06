import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:puzzlehack/interop.dart';
import 'package:puzzlehack/models/models.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc() : super(const PuzzleState()) {
    on<PlayerAdded>(_onPlayerAdded);
    on<PlayerRemoved>(_onPlayerRemoved);
    on<GameStarted>(_onGameStarted);
  }

  _onPlayerAdded(PlayerAdded event, Emitter<PuzzleState> emit) {
    var players = HashSet<Player>.from(state.players)..add(event.player);
    emit(state.copyWith(players: players.toList()));
  }

  _onPlayerRemoved(PlayerRemoved event, Emitter<PuzzleState> emit) {
    var players = HashSet<Player>.from(state.players)..remove(event.player);
    emit(state.copyWith(players: players.toList()));
  }

  _onGameStarted(GameStarted event, Emitter<PuzzleState> emit) {
    Interop.setGameState("playing");
    emit(state.copyWith(status: Status.playing));
  }
}
