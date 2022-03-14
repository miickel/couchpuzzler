part of 'gamepad_bloc.dart';

enum GamepadStatus { initial, waiting, ready, playing }

class GamepadState extends Equatable {
  const GamepadState(
      {this.status = GamepadStatus.initial,
      this.player,
      this.theme = const PlayerTheme(
        name: "Waiting...",
        primaryColor: Colors.black,
      )});

  final GamepadStatus status;
  final Player? player;
  final PlayerTheme theme;

  GamepadState copyWith({
    GamepadStatus? status,
    Player? player,
    PlayerTheme? theme,
  }) {
    return GamepadState(
      status: status ?? this.status,
      player: player ?? this.player,
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object> get props => [status, theme];
}
