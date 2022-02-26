import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:puzzlehack/interop.dart';
import 'package:puzzlehack/utils.dart';

import 'package:puzzlehack/models/models.dart';

part 'gamepad_event.dart';
part 'gamepad_state.dart';

class GamepadBloc extends Bloc<GamepadEvent, GamepadState> {
  GamepadBloc() : super(const GamepadState()) {
    on<GamepadInitialized>(_onGamepadInitialized);
    on<GameStateChanged>(_onGameStateChanged);
  }

  _onGamepadInitialized(GamepadInitialized event, Emitter<GamepadState> emit) {
    var player = JsPlayer(id: Utils.getRandomString(6));
    Interop.join(event.channelId, player);

    emit(state.copyWith(
      status: GamepadStatus.waiting,
      player: Player.fromJsPlayer(player),
    ));
  }

  _onGameStateChanged(GameStateChanged event, Emitter<GamepadState> emit) {
    switch (event.state) {
      case "waiting":
      case "ready":
        return emit(state.copyWith(status: GamepadStatus.waiting));
      case "playing":
        return emit(state.copyWith(status: GamepadStatus.playing));
    }
  }
}
