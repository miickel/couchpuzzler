part of 'gamepad_bloc.dart';

enum GamepadStatus { initial, waiting, playing }

class GamepadState extends Equatable {
  const GamepadState({this.status = GamepadStatus.initial, this.player});

  final GamepadStatus status;
  final Player? player;

  GamepadState copyWith({
    GamepadStatus? status,
    Player? player,
  }) {
    return GamepadState(
      status: status ?? this.status,
      player: player ?? this.player,
    );
  }

  @override
  List<Object> get props => [status];
}
