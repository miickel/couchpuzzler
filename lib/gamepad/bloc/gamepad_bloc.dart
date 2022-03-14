import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:puzzlehack/constants.dart';
import 'package:puzzlehack/interop.dart';
import 'package:puzzlehack/models/models.dart';
import 'package:puzzlehack/utils.dart';

part 'gamepad_event.dart';
part 'gamepad_state.dart';

class GamepadBloc extends Bloc<GamepadEvent, GamepadState> {
  GamepadBloc() : super(const GamepadState()) {
    on<GamepadInitialized>(_onGamepadInitialized);
    on<GameStateChanged>(_onGameStateChanged);
    on<PlayerChanged>(_onPlayerChanged);
    on<InputRegistered>(_onGamepadPressed);
  }

  _onGamepadInitialized(GamepadInitialized event, Emitter<GamepadState> emit) {
    var player = JsPlayer(id: Utils.getRandomString(6), theme: 0);
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

  _onPlayerChanged(PlayerChanged event, Emitter<GamepadState> emit) {
    var theme = playerThemes[event.player.theme];
    var player = Player.fromJsPlayer(event.player);
    emit(state.copyWith(theme: theme, player: player));
  }

  _onGamepadPressed(InputRegistered event, Emitter<GamepadState> emit) {
    Interop.registerInput(state.player!.id, event.input.index);
    if (state.status == GamepadStatus.waiting &&
        event.input == GamepadInput.ready) {
      emit(state.copyWith(status: GamepadStatus.ready));
    }
  }
}
