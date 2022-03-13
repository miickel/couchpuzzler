import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:puzzlehack/interop.dart';
import 'package:puzzlehack/models/models.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc({required this.playerThemes})
      : super(PuzzleState(playerThemes: playerThemes)) {
    on<PlayerAdded>(_onPlayerAdded);
    on<PlayerRemoved>(_onPlayerRemoved);
    on<GameStarted>(_onGameStarted);
    on<GamepadInputRegistered>(_onGamepadInputRegistered);
  }

  final List<PlayerTheme> playerThemes;

  _onPlayerAdded(PlayerAdded event, Emitter<PuzzleState> emit) {
    if (!state.players.any((e) => e.id == event.player.id)) {
      var player = _changePlayerTheme(event.player, 1);
      var players = state.players.toList()..add(player);
      emit(state.copyWith(players: players));
    }
  }

  _onPlayerRemoved(PlayerRemoved event, Emitter<PuzzleState> emit) {
    var players = state.players.toList()
      ..removeWhere((e) => e.id == event.player.id);
    emit(state.copyWith(players: players));
  }

  _onGameStarted(GameStarted event, Emitter<PuzzleState> emit) {
    Interop.setGameState("playing");
    emit(state.copyWith(status: Status.playing));
  }

  _onGamepadInputRegistered(
      GamepadInputRegistered event, Emitter<PuzzleState> emit) {
    var player = state.players.firstWhere((p) => p.id == event.playerId);
    var playerIndex = state.players.indexOf(player);
    var input = GamepadInput.values[event.input];

    switch (state.status) {
      case Status.lobby:
        if (input == GamepadInput.up || input == GamepadInput.down) {
          var players = state.players.toList();
          players[playerIndex] =
              _changePlayerTheme(player, input == GamepadInput.up ? 1 : -1);
          emit(state.copyWith(players: players));
        }
        break;
      case Status.playing:
        break;
    }
  }

  Player _changePlayerTheme(Player player, int step) {
    var activeThemes = state.players.map((p) => p.theme);
    var themeIndex = player.theme;
    var numThemes = state.playerThemes.length;

    while (activeThemes.contains(themeIndex)) {
      themeIndex = (themeIndex + step) % numThemes;
    }

    return player.copyWith(theme: themeIndex);
  }
}
