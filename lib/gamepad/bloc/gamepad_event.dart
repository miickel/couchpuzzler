part of 'gamepad_bloc.dart';

abstract class GamepadEvent extends Equatable {
  const GamepadEvent();

  @override
  List<Object> get props => [];
}

class GamepadInitialized extends GamepadEvent {
  const GamepadInitialized(this.channelId) : super();
  final String channelId;

  @override
  List<Object> get props => [channelId];
}

class GameStateChanged extends GamepadEvent {
  final String state;

  const GameStateChanged(this.state);
}
